package com.ssafy.birdchain.api.controller;

import com.ssafy.birdchain.api.service.AvailableProductService;
import com.ssafy.birdchain.common.db.dto.util.ResponseDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Log4j2
@RestController
@Tag(name = "NFT")
@RequiredArgsConstructor
@RequestMapping(value = "/nft")
public class AvailableProductController {

    private final AvailableProductService availableProductService;

    @GetMapping("available")
    @Operation(summary = "판매 가능한 NFT 번호 랜덤 반환")
    public ResponseEntity<ResponseDTO> giveMeNFTNumber() {
        return ResponseEntity.ok().body(ResponseDTO.of(HttpStatus.OK, "조회에 성공했습니다.", availableProductService.giveMeNFTNumber()));
    }

    @GetMapping("/images")
    @Operation(summary = "선택 가능한 NFT 이미지 조회")
    public ResponseEntity<ResponseDTO> showMeNFTImgs(@RequestParam String fileName) {
        return ResponseEntity.ok().body(ResponseDTO.of(HttpStatus.OK, "조회에 성공했습니다.", availableProductService.getFileUrl(fileName)));
    }
}

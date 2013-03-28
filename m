Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3C1XxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 19:53:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55712 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab3C1Xw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 19:52:59 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-e8-5154d7da33de
Message-id: <5154D7DC.3010604@samsung.com>
Date: Fri, 29 Mar 2013 08:53:00 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, patches@linaro.org
Subject: Re: [PATCH v2 1/2] extcon: max77693: Fix return value
References: <1364452053-17405-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1364452053-17405-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t8zbd1b10MCDTZ1cFlc3jWHzeJ24wo2
	iymHv7BYnPzTy+jA4nHn2h42j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mq48/8qU8Ej1ooP
	ux+zNjC+Y+li5OSQEDCRaNvQyARhi0lcuLeerYuRi0NIYBmjxLMtN9hhiu6f6GOFSExnlLhw
	4Q4jhPOCUeLvrxZGkCpeAS2JjmnNYGNZBFQlLt5ayQpiswHF97+4wQZiiwqESaycfoUFol5Q
	4sfke2C2CFDNy+7lQGdwcDAL+ElM3BsEEhYWsJM49e0F2HVCAu4SX9e+ACvnFPCQWHnrMtha
	ZgEdif2t09ggbHmJzWveMoPcJiGwjF3i1Y9rzBD3CEh8m3yIBWS+hICsxKYDzBCPSUocXHGD
	ZQKj2CwkF81CMnYWkrELGJlXMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYoRE0cQdjPcPWB9i
	TAZaOZFZSjQ5HxiFeSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgXLo53oJ3ZVoof/qPe4438/9LGr/Yav42auvu/tw1/xtWH1OOKkmoDwh/4ZIn
	ecjg+97vYpx/4gtiJaM3PeUWuvf12Lqprj7Xtt2Z8foh76J19kJrckMyr2WuuhEoZXAjYukp
	i/w3N06K2+y+POdftLX2QtEnuawXdBPPrSz91SORaJET4amXp8RSnJFoqMVcVJwIAIEUBuG4	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoO6t6yGBBou/sFhc3jWHzeJ24wo2
	iymHgdyTf3oZHVg87lzbw+bRt2UVo8fnTXIBzFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7x
	pmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QOuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqG
	BMH1GBmggYR1jBl3/l9lKnjEWvFh92PWBsZ3LF2MnBwSAiYS90/0sULYYhIX7q1n62Lk4hAS
	mM4oceHCHUYI5wWjxN9fLYwgVbwCWhId05rBulkEVCUu3loJ1s0GFN//4gYbiC0qECaxcvoV
	Foh6QYkfk++B2SJANS+7lzN1MXJwMAv4SUzcGwQSFhawkzj17QUTiC0k4C7xde0LsHJOAQ+J
	lbcug61lFtCR2N86jQ3ClpfYvOYt8wRGgVlINsxCUjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5
	xaV56XrJ+bmbGMEx+kxqB+PKBotDjAIcjEo8vDMiQgKFWBPLiitzDzFKcDArifBOOw8U4k1J
	rKxKLcqPLyrNSS0+xJgMDICJzFKiyfnA9JFXEm9obGJmZGlkZmxibmxMmrCSOO+BVutAIYH0
	xJLU7NTUgtQimC1MHJxSDYzN1/fv2uNasutAZNovneXihv+UpbZ65ctr8kkai7Ru4l5UWJWY
	bzTrrlF2Andro+zRnEK50HCX1Lkzew9uj1wZWsU1T2RWqXX63IOFV4T5pO5uDkxe4uWxP5dD
	+8DD0ImGJ/ne8mr0BkqE1Wj/m6h7t3HjyiqjnKPvS/y/PFD5VxdxWSREWomlOCPRUIu5qDgR
	AN9zQ+kVAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 03:27 PM, Sachin Kamat wrote:
> Return the value obtained from the function instead of hardcoding.
> Silences the following warnings:
> drivers/extcon/extcon-max77693.c:297 max77693_muic_set_path()
> info: why not propagate 'ret' from max77693_update_reg() instead of (-11)?
> drivers/extcon/extcon-max77693.c:310 max77693_muic_set_path()
> info: why not propagate 'ret' from max77693_update_reg() instead of (-11)?
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
> Changes since v1:
> Include additional instances.
> Compile tested.
> ---
>  drivers/extcon/extcon-max77693.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
Applied this patchset. Thanks.

Chanwoo Choi

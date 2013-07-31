Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422Ab3GaI7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:59:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23736 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759378Ab3GaI5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:57:14 -0400
X-AuditID: cbfee68e-b7f276d000002279-7e-51f8d168f9e8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] backlight: ld9040: Staticize local variable gamma_table
Date: Wed, 31 Jul 2013 17:57:12 +0900
Message-id: <002d01ce8dcb$f28d7f40$d7a87dc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6Ny+xTCd5smhD6S9K/x8QwboxIfg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zQ92Miz8CDd6fsbaYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDL6L29h
	Lmhjr1hxuImtgbGBrYuRk0NCwETi4fcVzBC2mMSFe+uB4lwcQgLLGCXOPLzJClN0dGonVGIR
	o8TdK3eYIZxfjBInVj1jAaliE1CT+PLlMHsXIweHiIC+RFuLBkiYWaBUYuuD9ywgYWEBH4mm
	Z2UgYRYBVYk5K/+DVfMKWErsnV8FEuYVEJT4MfkeC0SnlsT6nceZIGx5ic1r3kLdqSCx4+xr
	RhBbREBP4v//fkaIGhGJfS/eMYJcJiGwjV3i9JlZLBC7BCS+TT4EdoKEgKzEpgNQcyQlDq64
	wTKBUWwWktWzkKyehWT1LCQrFjCyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIibG+HYw3
	D1gfYkwGWj+RWUo0OR8Yo3kl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbF
	F5XmpBYfYmTi4JRqYFxXmHR/n82db/Entn3dfn2f3jt7D50Z1irsOptetm6wWpfrqtsezvMw
	jHtys9f8I0Y/72+tbTknaODkK22+b3brkj+1d7b3nfpeLt1fbS3Rvt5i1y0Pv9e73VpMmatE
	+XgumdWlCW3S+W1dWJPufKiUvVai5H+86tRla3Q45z7KXbOa71+8khJLcUaioRZzUXEiAN7A
	M93HAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd2Miz8CDfa9M7eYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgz+i9vYS5oY69YcbiJrYGxga2LkZNDQsBE4ujUTihbTOLCvfVA
	NheHkMAiRom7V+4wQzi/GCVOrHrGAlLFJqAm8eXLYfYuRg4OEQF9ibYWDZAws0CpxNYH71lA
	wsICPhJNz8pAwiwCqhJzVv4Hq+YVsJTYO78KJMwrICjxY/I9FohOLYn1O48zQdjyEpvXvGWG
	OEdBYsfZ14wgtoiAnsT///2MEDUiEvtevGOcwCgwC8moWUhGzUIyahaSlgWMLKsYRVMLkguK
	k9JzDfWKE3OLS/PS9ZLzczcxgiP4mdQOxpUNFocYBTgYlXh4HS58DxRiTSwrrsw9xCjBwawk
	wisf9CNQiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OBySWvJN7Q2MTMyNLIzMLIxNycNGEl
	cd4DrdaBQgLpiSWp2ampBalFMFuYODilGhgb7/1e+8l215FPOh++S8uyfXnTU5mv3bRuc031
	G6Hk8kk2DyxWxP68ynt/ssiM5+3eepNPn42yPbf4gkWs5L032gL2/xaxe9sZX+FQ7+8o6Du9
	p7nEPEqu5/fcqwahrgxf3+n1VK2Pbvv1Stgq7sGjgN83CpJPtp5Y++gmo9T0jV2qz9Wj175V
	YinOSDTUYi4qTgQAZxIdbSQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings:

drivers/video/backlight/ld9040_gamma.h:172:3: warning: symbol 'gamma_table' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ld9040_gamma.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/ld9040_gamma.h b/drivers/video/backlight/ld9040_gamma.h
index 038d9c8..160f07a 100644
--- a/drivers/video/backlight/ld9040_gamma.h
+++ b/drivers/video/backlight/ld9040_gamma.h
@@ -169,7 +169,7 @@ static const unsigned int ld9040_22_50[] = {
 
 struct ld9040_gamma {
 	unsigned int *gamma_22_table[MAX_GAMMA_LEVEL];
-} gamma_table = {
+} static gamma_table = {
 	.gamma_22_table[0] = (unsigned int *)&ld9040_22_50,
 	.gamma_22_table[1] = (unsigned int *)&ld9040_22_70,
 	.gamma_22_table[2] = (unsigned int *)&ld9040_22_80,
-- 
1.7.10.4



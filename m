Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3HLDfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 23:35:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29256 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3HLDfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 23:35:54 -0400
X-AuditID: cbfee691-b7fef6d000002d62-6c-520858136b82
From: Jingoo Han <jg1.han@samsung.com>
To: "'Alessandro Rubini'" <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] FMC: Staticize local symbols
Date: Mon, 12 Aug 2013 12:35:46 +0900
Message-id: <000001ce970d$085302b0$18f90810$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6XDPTcT6eFOvHjReSl4QF8DffxnA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zfV3hCI4gg7+P+CyaF69ns7i88BKr
	xeVdc9gsfp9MdmDx2Np6gNVj/9w17B59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CV0fJAq2Au
	Z8X7Z3OYGxjPsncxcnJICJhIrHi+ghnCFpO4cG89WxcjF4eQwDJGicU7bzDBFB1b8IUdIjGd
	UWLH/pdMEM4vIOfvAbBRbAJqEl++HAazRQS0JG62fGADsZkFyiVm3n8EtIKDQ1hAV+LPOnOQ
	MIuAqsS7S+2sIDavgKXE5v8zWCBsQYkfk++xQLRqSazfeZwJwpaX2LzmLdSlChI7zr5mhFil
	J3F2bQMrRI2IxL4X7xhBbpMQWMUu0bS7gwVimYDEt8mHWEBukBCQldh0AGqOpMTBFTdYJjCK
	zUKyehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCExNnEH4/0D1ocY
	k4HWT2SWEk3OB8ZoXkm8obGZkYWpiamxkbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmp
	xYcYmTg4pRoYp19r/6J3YMWJ6NUvHreH/ZNpXvh863PlE1JJET2d09bcnHDdc/01p/WOlcsP
	epek8038WVnKN/e9RzvPyzWeJz4fcwlj0dBkmGgklzk7Tlairmon+87GfZ3K5596fPC1kzPR
	CKmskb7IzthzUNXeovJ32smunujycgt35V/1WWVsiSGvO3yVWIozEg21mIuKEwFNPUsjxwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQV3hCI4ggy0d3BbNi9ezWVxeeInV
	4vKuOWwWv08mO7B4bG09wOqxf+4ado++LasYPT5vkgtgiWpgtMlITUxJLVJIzUvOT8nMS7dV
	8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBWqmkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxjzGh5oFUwl7Pi/bM5zA2MZ9m7GDk5JARMJI4t+AJli0lcuLeerYuR
	i0NIYDqjxI79L5kgnF9Azt8DYFVsAmoSX74cBrNFBLQkbrZ8YAOxmQXKJWbef8TcxcjBISyg
	K/FnnTlImEVAVeLdpXZWEJtXwFJi8/8ZLBC2oMSPyfdYIFq1JNbvPM4EYctLbF7zlhniIAWJ
	HWdfM0Ks0pM4u7aBFaJGRGLfi3eMExgFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rpFe
	cWJucWleul5yfu4mRnAEP5PewbiqweIQowAHoxIPr8cX9iAh1sSy4srcQ4wSHMxKIrxMPhxB
	QrwpiZVVqUX58UWlOanFhxiTgT6dyCwlmpwPTC55JfGGxiZmRpZGZhZGJubmpAkrifMebLUO
	FBJITyxJzU5NLUgtgtnCxMEp1cDYoXWkvjetyeN0wre91o3pr5hmxDKy85xKybKTX7Ly0Cqe
	H3tCbhaHxPt83fpP+9Fa9s9b6wUWW3+3q2LvSkvOtRVQ/T+BT8hI3Schb8qLvTsCo1SuPe8Q
	nKFy2EZ8Ya/bQfs8W02Gbo2DeRbcKfMWTz7qLXgrjFlMt3ZWYuhMU0WHO1yaRUosxRmJhlrM
	RcWJAJAc2WIkAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This local symbol is used only in this file.
Fix the following sparse warnings:

drivers/fmc/fmc-write-eeprom.c:106:5: warning: symbol 'fwe_probe' was not declared. Should it be static?
drivers/fmc/fmc-write-eeprom.c:147:5: warning: symbol 'fwe_remove' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/fmc/fmc-write-eeprom.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/fmc/fmc-write-eeprom.c b/drivers/fmc/fmc-write-eeprom.c
index 2cc680d..ee5b479 100644
--- a/drivers/fmc/fmc-write-eeprom.c
+++ b/drivers/fmc/fmc-write-eeprom.c
@@ -103,7 +103,7 @@ static int fwe_run(struct fmc_device *fmc, const struct firmware *fw, char *s)
  * difficult to know in advance when probing the first card if others
  * are there.
  */
-int fwe_probe(struct fmc_device *fmc)
+static int fwe_probe(struct fmc_device *fmc)
 {
 	int err, index = 0;
 	const struct firmware *fw;
@@ -144,7 +144,7 @@ int fwe_probe(struct fmc_device *fmc)
 	return 0;
 }
 
-int fwe_remove(struct fmc_device *fmc)
+static int fwe_remove(struct fmc_device *fmc)
 {
 	return 0;
 }
-- 
1.7.10.4



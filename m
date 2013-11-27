Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536Ab3K0Bwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:52:46 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:48914 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759706Ab3K0Bwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:52:42 -0500
X-AuditID: cbfee691-b7f666d0000048b0-31-529550693208
Date: Wed, 27 Nov 2013 01:52:41 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH] mn10300 : Kill CONFIG_MTD_PARTITIONS
To: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com
Cc: linux-am33-list@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20131127015121423@eunb.song
Msgkey: 20131127015121423@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131127015121423@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <6336985.82081385517159553.JavaMail.weblogic@epml11>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+Zpm5mwNQgg72fBCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGkRedTAWHeCs+Pc1sYJzA28XIySEkoCLR8v87I4gtIWAisXHu
	ZihbTOLCvfVsXYxcQDXLGCVa3m5ggyk69OEiC0RiPqPEnPnvmEESLAKqEvMOTGACsdkEtCV+
	HLgKFhcWMJX4dPsvC4gtIuAq8fXeA6A4BwezQIrEtxeSEEfIS0w+fZkdxOYVEJQ4OfMJC0iJ
	hICSxJfJ7hBhZYmWU51QJ0hIzJp+gRXC5pWY0f6UBcKWk5j2dQ0zhC0tcX7WBrhfFn9/DBXn
	lzh2ewcTxHheiSf3g2HG7N78BWq8gMTUMwcZIUrUJX79hprCJ7Fm4VsWmCm7Ti1nhmm9v2Uu
	2N/MAooSU7ofskPYWhJffuxjQ/UUiO0gsWp1K/sERuVZSFKzkLTPQtKOrGYBI8sqRtHUguSC
	4qT0IlO94sTc4tK8dL3k/NxNjJCEMHEH4/0D1ocYk4HxMZFZSjQ5H5hQ8kriDY3NjCxMTUyN
	jcwtzUgTVhLnTX+UFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBsalqy+P2l83TurKcc9JU
	qg5Ey+vvyzP9mF7HLnnYI2vBlflu7LMyRIRPxqW/PcO3T23bdMeFKnG3eM1qpjr8nlf6dt/T
	pSvrCy2k6m5ItPRY5C/XPJYxN63ry9xpz9v1q9ckp6s17tBcY/pS+numQOdBgXV7GX6EzOfS
	f9zIsrY+cpZiq3awEktxRqKhFnNRcSIAci2qpR4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t/tGbqZAVODDHa85LW4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GUdedDIVHOKt+PQ0s4FxAm8XIyeHkICKRMv/74wgtoSAicShDxdZIGwxiQv31rN1MXIB1cxn
	lJgz/x0zSIJFQFVi3oEJTCA2m4C2xI8DV8HiwgKmEp9u/wVrFhFwlfh67wFQnIODWSBF4tsL
	SYhd8hKTT19mB7F5BQQlTs58wgJSIiGgJPFlsjtEWFmi5VQnG8QJEhKzpl9ghbB5JWa0P4U6
	TU5i2tc1zBC2tMT5WRsYYU5e/P0xVJxf4tjtHUwQ43klntwPhhmze/MXqPECElPPHGSEKFGX
	+PUbagqfxJqFb1lgpuw6tZwZpvX+lrlgfzMLKEpM6X7IDmFrSXz5sY8N1VMgtoPEqtWt7BMY
	5WYhSc1C0j4LSTuymgWMLKsYRVMLkguKk9IrjPSKE3OLS/PS9ZLzczcxglPTs0U7GP+dtz7E
	KMDBqMTDO+HylCAh1sSy4srcQ4wSHMxKIrwvHKYGCfGmJFZWpRblxxeV5qQWH2JMBsbeRGYp
	0eR8YNrMK4k3NDYwNjS0NDcwNTSyIE1YSZxX/lZSkJBAemJJanZqakFqEcwWJg5OqQbGWSmy
	V8LeKWv+b+44+/jipDB12QMd7X8XR6Wl2Ifvs+Jg2roq2zeEy2Gfa4aL5t/KSF470S8T1s1R
	VAx3vtB476vgThkul/fnz+26brkuYNM+o0fFV+/evZe4WTGyONzK/132ut5Jc8IrHqV2H2L8
	oHhMkEFF5HjHNJFOfkdT2blPJ/YaOdxQYinOSDTUYi4qTgQAb+CFmpEDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAR1qoPB017636


This patch removes CONFIG_MTD_PARTITIONS in config files for mn10300.
Because CONFIG_MTD_PARTITIONS was removed by commit 6a8a98b22b10f1560d5f90aded4a54234b9b2724.

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 arch/mn10300/configs/asb2303_defconfig |    1 -
 arch/mn10300/configs/asb2364_defconfig |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/mn10300/configs/asb2303_defconfig b/arch/mn10300/configs/asb2303_defconfig
index 1fd41ec..591ab65 100644
--- a/arch/mn10300/configs/asb2303_defconfig
+++ b/arch/mn10300/configs/asb2303_defconfig
@@ -34,7 +34,6 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_WIRELESS is not set
 CONFIG_MTD=y
 CONFIG_MTD_DEBUG=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/mn10300/configs/asb2364_defconfig b/arch/mn10300/configs/asb2364_defconfig
index fbb96ae..fbaac16 100644
--- a/arch/mn10300/configs/asb2364_defconfig
+++ b/arch/mn10300/configs/asb2364_defconfig
@@ -51,7 +51,6 @@ CONFIG_IPV6=y
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
 CONFIG_MTD_DEBUG=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
 CONFIG_MTD_CHAR=y
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

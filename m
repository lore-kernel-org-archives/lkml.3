Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaFKJY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:24:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64985 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaFKJYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:24:54 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-c6-539820649a76
Date: Wed, 11 Jun 2014 09:24:52 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: mips: math-emu: Fix compilation error ieee754.c
To: ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20140611092245298@eunb.song
Msgkey: 20140611092245298@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140611092245298@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <2463243.264261402478691777.JavaMail.weblogic@epml26>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsVy+t8zPd0UhRnBBstOS1tc3jWHzYHR4/Mm
	uQDGqAZGm8Si5IzMslSF1Lzk/JTMvHRbpdAQN10LJYWM/OISW6VoIwNjPSNTEz0jE3M9S4NY
	KyNTJYW8xNxUW6UKXaheJYWi5AKg2tzKYqABOal6UHG94tS8FIes/FKQS/SKE3OLS/PS9ZLz
	c5UUyhJzSoFGKOknTGXM6Jy/kq3gA0/FkS/n2BoYD/B0MXJyCAmoSLT8/84IYksImEjcX7WC
	CcIWk7hwbz1bFyMXUM0yRokVi4+zwRT92P0aKjGHUeL1tlMsIAkWAVWJ+0t/g01iE9CW+HHg
	KjOILSxgIfF+0kuwZhEBGYmln66A1TALuEucX7CDBeIKeYnJpy+zg9i8AoISJ2c+YYFYpiRx
	tv8RG0RcWeJi6z9WiLiExKzpF6BsXokZ7U+h6uUkpn1dwwxhS0ucn7WBEeabxd8fQ8X5JY7d
	3gH0JQdY75P7wTBjdm/+AvWjgMTUMwehWtUl/t7bBRXnk1iz8C3UKkGJ09e6mWF672+ZywTx
	lqLElO6H7BC2lsSXH/vY0L3FK+Ao0TDjNuMERuVZSFKzkLTPQtKOrGYBI8sqRtHUguSC4qT0
	IiPk2N7ECEmEfTsYbx6wPsS4nxEYJxOZpUST84GpNK8k3tDYzMjC1MTU2Mjc0oxCYRNTCwsT
	I6oIK4nzLnqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcXUJ69v2Kpt46/gdh5N0GLo/
	dRkdm3Ik3tf6z4Sdjodav2vKWzyULxA1lYlKKCrI/XXBQK3/wMqQtlidyXL9B7WEEho8ja7p
	+xi+nLTm6cN4e8frZzfvXdR19aPYjinn5xT9/pQipHq1qfDEy/jXJfP+5V29cPLrDVPZo9Xu
	U9dfaNO+zNlVr8RSnJFoqMVcVJwIAC7Ns3D3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e92r26Kwoxgg6NHJSwu75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	Ruf8lWwFH3gqjnw5x9bAeICni5GTQ0hARaLl/3dGEFtCwETix+7XbBC2mMSFe+uBbC6gmjmM
	Eq+3nWIBSbAIqErcX/obrIFNQFvix4GrzCC2sICFxPtJL8GaRQRkJJZ+ugJWwyzgLnF+wQ4W
	iGXyEpNPX2YHsXkFBCVOznzCArFMSeJs/yM2iLiyxMXWf6wQcQmJWdMvQNm8EjPan0LVy0lM
	+7qGGcKWljg/awMjzNGLvz+GivNLHLu9g6mLkQOs98n9YJgxuzd/gfpRQGLqmYNQreoSf+/t
	gorzSaxZ+BZqlaDE6WvdzDC997fMZYJ4S1FiSvdDdghbS+LLj31s6N7iFXCUaJhxm3ECo9ws
	JKlZSNpnIWlHVrOAkWUVo2hqQXJBcVJ6hYlecWJucWleul5yfu4mRnCKerZkB2PDBetDjAIc
	jEo8vAckpgcLsSaWFVfmHmKU4GBWEuHdKTwjWIg3JbGyKrUoP76oNCe1+BBjMjACJzJLiSbn
	A9NnXkm8obGBsaGhpbmBqaGRBWnCSuK8C24lBQkJpCeWpGanphakFsFsYeLglGpgZL3PrVEr
	yfXu7oJb805nOs5bdIT5/dQE7vs3eX2yG5fMDl5/ueDI5Fxr2765bM1/j5p1KjtaJDD7rz96
	+HSdcbnXhgcWN2S9fztplFb+2PXAgW+HhoG87NWbS9JyPNa52nSffjX9iLvWOUdFLh7J2f8+
	rer1W18/a8XlxJ6bwVKcn+/kBXB6KrEUZyQaajEXFScCAMpm9jmVAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5B9P1Wp029100


ieee754dp has bitfield member in struct without name. And this
cause compilation error. This patch removes struct in ieee754dp
declaration. So compilation error is fixed.
Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 arch/mips/math-emu/ieee754.h |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)
diff --git a/arch/mips/math-emu/ieee754.h b/arch/mips/math-emu/ieee754.h
index 43c4fb5..c6e28b8 100644
--- a/arch/mips/math-emu/ieee754.h
+++ b/arch/mips/math-emu/ieee754.h
@@ -32,22 +32,18 @@
 #include <asm/bitfield.h>
 
 union ieee754dp {
- struct {
-  __BITFIELD_FIELD(unsigned int sign:1,
-  __BITFIELD_FIELD(unsigned int bexp:11,
-  __BITFIELD_FIELD(u64 mant:52,
-  ;)))
- };
+ __BITFIELD_FIELD(unsigned int sign:1,
+ __BITFIELD_FIELD(unsigned int bexp:11,
+ __BITFIELD_FIELD(u64 mant:52,
+ ;)))
  u64 bits;
 };
 
 union ieee754sp {
- struct {
-  __BITFIELD_FIELD(unsigned sign:1,
-  __BITFIELD_FIELD(unsigned bexp:8,
-  __BITFIELD_FIELD(unsigned mant:23,
-  ;)))
- };
+ __BITFIELD_FIELD(unsigned sign:1,
+ __BITFIELD_FIELD(unsigned bexp:8,
+ __BITFIELD_FIELD(unsigned mant:23,
+ ;)))
  u32 bits;
 };
 
-- 
1.7.0.1ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

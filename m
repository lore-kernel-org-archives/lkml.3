Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3DQAJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:09:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59063 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab3DQAJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:09:24 -0400
X-AuditID: cbfee68d-b7f786d000005188-e1-516de82eb140
Date: Wed, 17 Apr 2013 00:09:18 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: [PATCH] um: set CONFIG_LOCKDEP_SUPPORT to CONFIG_LOCKDEP
To: jdike@addtoit.com, richard@nod.at
Cc: user-mode-linux-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130417000516491@eunb.song
Msgkey: 20130417000516491@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130417000516491@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <8414166.322181366157356551.JavaMail.weblogic@epml27>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+Ztq7ei9xAg6/neS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG7ZMv2Qs2sVXcXbWCpYFxBlsXIyeHkICKRMv/74wgtoSAicSX
	u29YIWwxiQv31gPVcAHVLGOU6Fnzhg2m6O/9qSwQzfMZJfbPtQGxWQRUJZ5MOccOYrMJaEu8
	/fIAbJCwgKNEe9NbsHoRAUOJxo9NYMuYBUol3txfxAwxR15i8unLYL28AoISJ2c+YYHYpSQx
	Y+93IJsdKK4ssUMeIiohMWv6BagzeSVmtD+FqpaTmPZ1DTOELS1xftYGRphXFn9/DBXnlzh2
	ewdTFyMHWO+T+8EwY3Zv/gL1oIDE1DMHGSFK1CUWnneECPNJrFn4lgVmyq5Ty5lhWu9vmcsE
	8ZOixJTuh+wQtpbElx/72ND9xAsMj5Wnd7JPYFSehSQ1C0n7LCTtyGoWMLKsYhRNLUguKE5K
	LzLUK07MLS7NS9dLzs/dxAhJCL07GG8fsD7EmAyMj4nMUqLJ+cCEklcSb2hsZmRhamJqbGRu
	aUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRl6enGxe6c9OX3MvnZz0V3hT
	a6V804+7rC/mtsuumfl2qazvmcufqnxDNxzPb0zi1jSb7duSqHhiq5Ns2o2McvskPe6XS0TP
	bnRfeckmrWnhyTcTXl9mL9kYczZryoUjf63s5mTYnOV67PDpHD+75xudYzMdGStFK34ZZx45
	8cunTDNl7vuDBUosxRmJhlrMRcWJACzaquweAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsVy+t/t6bp6L3IDDXp6uS0u75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xu2TL9kLNrFV3F21gqWBcQZbFyMnh5CAikTL/++MILaEgInE3/tTWSBsMYkL99ZD1cxnlNg/
	1wbEZhFQlXgy5Rw7iM0moC3x9ssDVhBbWMBRor3pLViviIChROPHJrCZzAKlEm/uL2KGmCMv
	Mfn0ZbBeXgFBiZMzn0DtUpKYsfc7kM0OFFeW2CEPEZWQmDX9AiuEzSsxo/0pVLWcxLSva5gh
	bGmJ87M2MMJcvPj7Y6g4v8Sx2zuYuhg5wHqf3A+GGbN78xc2CFtAYuqZg4wQJeoSC887QoT5
	JNYsfMsCM2XXqeXMMK33t8xlgvhJUWJK90N2CFtL4suPfWzofuIFhsfK0zvZJzDKzUKSmoWk
	fRaSdmQ1CxhZVjGKphYkFxQnpVcY6xUn5haX5qXrJefnbmIEp6Zni3cw/j9vfYhRgINRiYf3
	QkFuoBBrYllxZe4hRgkOZiURXsVVQCHelMTKqtSi/Pii0pzU4kOMycDYm8gsJZqcD0ybeSXx
	hsYGxoaGluYGpoZGFqQJK4nzPmu1DhQSSE8sSc1OTS1ILYLZwsTBKdXAGBny2+VXz0rDBN6z
	N7b/nuIU8Hjx+j+rbIr/3wtoMGL5EF0wYWLtwQ1TTb5+nfxkup9vTx7H5GVHNuseONz4uEgk
	wSzWY4XJ5Akl6e99/wZX26Rb7GV69lvtWeDpgKBNaTK6fRcDlC90z0gt2W4nabZsMm/OhOlr
	5/k8etE50/Buf9QLziM7ViixFGckGmoxFxUnAgDrow3ZkQMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3H09WXI006214


CONFIG_LOCKDEP_SUPPORT is no longer valid.

Singed-off-by: EunBong Song <eunb.song@samsung.com>

---
 arch/um/defconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/defconfig b/arch/um/defconfig
index 08107a7..bbc5aa7 100644
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -7,7 +7,7 @@ CONFIG_UML=y
 CONFIG_MMU=y
 CONFIG_NO_IOMEM=y
 # CONFIG_TRACE_IRQFLAGS_SUPPORT is not set
-CONFIG_LOCKDEP_SUPPORT=y
+CONFIG_LOCKDEP=y
 # CONFIG_STACKTRACE_SUPPORT is not set
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_GENERIC_BUG=y
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3ETJ7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:59:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60454 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab3ETJ7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:59:32 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-14-5199f3feac79
Date: Mon, 20 May 2013 09:44:42 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: [PATCH] mips: Fix compilation warning
To: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "david.daney@cavium.com" <david.daney@cavium.com>
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130520093721431@eunb.song
Msgkey: 20130520093721431@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130520093721431@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <151291.150571369043081270.JavaMail.weblogic@epml03>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+Zru6/zzMDDSYuE7C4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZN76+Zi94w1XRe/4TcwPjEa4uRk4OIQEViZb/3xlBbAkBE4nV
	+74zQdhiEhfurWfrYuQCqlnGKNF07hJc0ftLS6AS8xkl7q1exgqSYBFQlfh3eQ9YEZuAtsTb
	Lw/A4sICehLv108Fi4sIpEjsXHaQGcRmFqiR6P67mBHiCnmJyacvs4PYvAKCEidnPmGBWKYk
	8ezWSkaIuLLEtzdTWSHiEhKzpl+AsnklZrQ/haqXk5j2dQ0zhC0tcX7WBkaYbxZ/fwwV55c4
	dnsH0JccYL1P7gfDjNm9+QsbhC0gMfXMQahWdYltzbOhxvNJrFn4lgVmzK5Ty5lheu9vmcsE
	8ZaixJTuh+wQtpbElx/72NC9xSvgILGxaSHzBEblWUhSs5C0z0LSjqxmASPLKkbR1ILkguKk
	9CJDveLE3OLSvHS95PzcTYyQxNC7g/H2AetDjMnAKJnILCWanA9MLHkl8YbGZkYWpiamxkbm
	lmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYPSSqVbbLzf1Up7LtJVr3Y//
	2xnNwnct/0L22+aAA55ejisT7RfXmy5+4hLF6VRYevGeZ+OujeH/JxorlrsZZliEMO5rDGDn
	sFuvrWhbd7tmBXNKRSbnMe3suY2hB/XiKwKN8n6Z/G6Xt5v4ODad9YXhW46ron+fBq6Yep17
	9fsjD2LvH4+zUGIpzkg01GIuKk4EAItMTIEiAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2TN1/n2cGGhw+ympxedccNgdGj8+b
	5AIYozJsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaKNDIz1jExN9IyMDfRMDGKtDA0MjEyBqhIy
	Mm58fc1e8Iarovf8J+YGxiNcXYycHEICKhIt/78zgtgSAiYS7y8tYYOwxSQu3FsPZHMB1cxn
	lLi3ehkrSIJFQFXi3+U9YA1sAtoSb788AIsLC+hJvF8/FSwuIpAisXPZQWYQm1mgRqL772JG
	iGXyEpNPX2YHsXkFBCVOznzCArFMSeLZrZWMEHFliW9vprJCxCUkZk2/AGXzSsxofwpVLycx
	7esaZghbWuL8rA2MMEcv/v4YKs4vcez2DqYuRg6w3if3g2HG7N78BepHAYmpZw5CtapLbGue
	DTWeT2LNwrcsMGN2nVrODNN7f8tcJoi3FCWmdD9kh7C1JL782MeG7i1eAQeJjU0LmScwys1C
	kpqFpH0WknZkNQsYWVYxiqYWJBcUJ6VXmOgVJ+YWl+al6yXn525iBKeoZ0t2MDZcsD7EKMDB
	qMTDKxAwM1CINbGsuDL3EKMEB7OSCG90N1CINyWxsiq1KD++qDQntfgQYzIwAicyS4km5wPT
	Z15JvKGxgbGhoaW5gamhkQVpwkrivM9arQOFBNITS1KzU1MLUotgtjBxcEo1ME7db8F7iuvw
	wpMNQtf37M505XM+8/61XLJBSKbN7VXbJ9+8u/c127WFnZqlzEILIw4/eTJ58+ONgYFrMkQz
	Z9fPuLTk7ApdjZw1ywTfSU5+Yxt6WefQ0ioxT+nYm8dKhbbOOGggOLNTZl6Rpcb31akts7bv
	nHJB3yQhtry9sUan7bBret2+K0+UWIozEg21mIuKEwF78rH8lQMAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4K9xpEI010935


Fix the following compilation warning:

mm/page_alloc.c: In function 'free_reserved_area':
mm/page_alloc.c:5162: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast
/home/ebsong/backup/linux_git/linux/arch/mips/include/asm/io.h:119: note: expected 'const volatile void *' but argument is
of type 'long unsigned int'
---
 arch/mips/include/asm/page.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index ec1ca53..41640f1 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -197,7 +197,7 @@ typedef struct { unsigned long pgprot; } pgprot_t;
 
 #endif
 
-#define virt_to_page(kaddr)	pfn_to_page(PFN_DOWN(virt_to_phys(kaddr)))
+#define virt_to_page(kaddr)	pfn_to_page(PFN_DOWN(virt_to_phys((const volatile void *)(kaddr))))
 
 extern int __virt_addr_valid(const volatile void *kaddr);
 #define virt_addr_valid(kaddr)						\
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

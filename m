Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545Ab3BYCUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 21:20:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:35055 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759438Ab3BYCUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 21:20:31 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-09-512aca684ad7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Greg KH'" <greg@kroah.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000301ce10bf$028176c0$07846440$%han@samsung.com>
In-reply-to: <000301ce10bf$028176c0$07846440$%han@samsung.com>
Subject: [PATCH V2] lib: devres: Fix misplaced #endif
Date: Mon, 25 Feb 2013 11:20:24 +0900
Message-id: <01fa01ce12fe$ab133940$0139abc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QvwIQvVMe0phTShywU8x8ewbKvgCP3FHA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zQ92MU1qBBnNbJS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGvK2/mQoWcVes/fqJuYFxL2cXIyeHhICJxJ9TX5khbDGJC/fW
	s3UxcnEICSxjlPg+tZMFpmjrln2MEIlFjBIPfl1hA0kICcxmkrixQRvEZhNQk/jy5TB7FyMH
	h4iAvkRbiwZImFkgSeL041awsJCArcSFtjqQMKeAncTlK3tZQWxhAVOJFR9PgU1kEVCVmD9n
	MTNIOS9Q+cnzqSBhXgFBiR+T77FATNSSWL/zOBOELS+xec1bsHIJAXWJR391QcIiAkYSv66u
	YYUoEZHY9+Id2PESAsvYJS7c+cwCsUpA4tvkQywQvbISmw5AQ0FS4uCKGywTGCVmIdk8C8nm
	WUg2z0KyYgEjyypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MkJiauIPx/gHrQ4zJQOsnMkuJ
	JucDYzKvJN7Q2NjEzMTUxNzS1NyUNGElcV75SzKBQgLpiSWp2ampBalF8UWlOanFhxiZODil
	GhgXf6w4/Hde1QaOLUwHZtbO5308U+zol/1LYnccPyRVY6P5LSbl8NmlV9a89DHeNfWKm7Kd
	2Vkh47Y/adtWT61pVRDueNV3RNF+WzAvo890gWUaZvZX5M4YPjpT4HDuefOzbH8nbe5CPpaa
	zW/+yBZsSbo4cztjP8e8VacqBVj1eMP9wnfYiDUqsRRnJBpqMRcVJwIAciUtar8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xgG7GKa1Ag9bjIhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY97W30wFi7gr1n79xNzA
	uJezi5GTQ0LARGLrln2MELaYxIV769m6GLk4hAQWMUo8+HWFDSQhJDCbSeLGBm0Qm01ATeLL
	l8PsXYwcHCIC+hJtLRogYWaBJInTj1vBwkICthIX2upAwpwCdhKXr+xlBbGFBUwlVnw8BTaR
	RUBVYv6cxcwg5bxA5SfPp4KEeQUEJX5MvscCMVFLYv3O40wQtrzE5jVvwcolBNQlHv3VBQmL
	CBhJ/Lq6hhWiRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFp
	Xrpecn7uJkZwxD6T3sG4qsHiEKMAB6MSD2/DSq1AIdbEsuLK3EOMEhzMSiK8mqFAId6UxMqq
	1KL8+KLSnNTiQ4zJQH9OZJYSTc4HJpO8knhDYxMzI0sjMwsjE3Nz0oSVxHkZTz0JEBJITyxJ
	zU5NLUgtgtnCxMEp1cAYvOLAZ3326Pcb7x4O4H/U8jTOYN7qTWtPnb+s3l18w05l6xO+1ReM
	naR2tInqKHBWhxywsxf5taNMZqq6IkN/dcY5lae1/NdXVMTezHF6YnClYMHeV1mvO2bsnfeF
	76byNaUEh8nfzn6pe1kXMWfyjqsL9LJv+E9mW6BUNr3pGZeOluPtmE9SSizFGYmGWsxFxYkA
	fT071RwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A misplaced #endif causes link errors related to pcim_*() functions.

This is because pcim_*() functions are related to CONFIG_PCI
option, however these are not related to CONFIG_HAS_IOPORT option.
Therefore, when CONFIG_PCI is enabled and CONFIG_HAS_IOPORT is not
enabled, it makes link errors related to pcim_*() functions
as below:

drivers/ata/libata-sff.c:3233: undefined reference to `pcim_iomap_regions'
drivers/ata/libata-sff.c:3238: undefined reference to `pcim_iomap_table'
drivers/built-in.o: In function `ata_pci_sff_init_host':
drivers/ata/libata-sff.c:2318: undefined reference to `pcim_iomap_regions'
drivers/ata/libata-sff.c:2329: undefined reference to `pcim_iomap_table

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- Added more detailed commit message

 lib/devres.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/devres.c b/lib/devres.c
index 88ad759..8235331 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -227,6 +227,7 @@ void devm_ioport_unmap(struct device *dev, void __iomem *addr)
 			       devm_ioport_map_match, (void *)addr));
 }
 EXPORT_SYMBOL(devm_ioport_unmap);
+#endif /* CONFIG_HAS_IOPORT */
 
 #ifdef CONFIG_PCI
 /*
@@ -432,4 +433,3 @@ void pcim_iounmap_regions(struct pci_dev *pdev, int mask)
 }
 EXPORT_SYMBOL(pcim_iounmap_regions);
 #endif /* CONFIG_PCI */
-#endif /* CONFIG_HAS_IOPORT */
-- 
1.7.2.5



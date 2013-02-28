Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3B1IjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:39:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:47473 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab3B1IjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:39:10 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-aa-512f17a6f294
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 02/19] rtc: rtc-davinci: remove erroneous __init annotation
Date: Thu, 28 Feb 2013 17:39:01 +0900
Message-id: <00a601ce158f$0f036370$2d0a2a50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAAAe7w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zA91l4vqBBke6OSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKeHnjIVvBPPaKxXPbmRoY+9m6GDk5JARMJBbd7YWyxSQu3FsPZHNxCAksY5Q4vvUT
	C0zRrd93mSES0xklps9cyQ7h/GKUmLjxOTtIFZuAmsSXL4eBbA4OEQF9ibYWDZAaZoFeRokz
	vbvBaoQEbCWOtbWBTeUUsJP4/fQoK4gtLOAtMW/eCmYQm0VAVeJ772Wwk3iB6tcevcUCYQtK
	/Jh8D8xmFtCSWL/zOBOELS+xec1bZpC9EgLqEo/+6oKERQSMJE6egjiNWUBEYt+Ld4wg90gI
	3GOX6J/zlAlil4DEt8mHWCB6ZSU2HWCGeFhS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG
	0dSC5ILipPQiU73ixNzi0rx0veT83E2MkFiduIPx/gHrQ4zJQOsnMkuJJucDYz2vJN7Q2NjE
	zMTUxNzS1NyUNGElcV75SzKBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhXen7SPfrp2KvW
	7z/VE+pWeG6fn/hAZuX3RaW+2QJ6WVN+bL3oJ1T9as9c+QlTrvkc/PrCbOZN/S3B+y+yaz97
	JOY561/15CNHPoXuLxDZu/HQMZ4n8a5S6z97t8od/yr5w13ew4Pf5Xanht5/ltcf2v83fG/M
	2/hS0vtzbm/qOsHr7w7GOOzuVWIpzkg01GIuKk4EAOlb3lDrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd1l4vqBBm9OMlssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPHyxkO2gnnsFYvntjM1MPazdTFyckgImEjc
	+n2XGcIWk7hwbz1QnItDSGA6o8T0mSvZIZxfjBITNz5nB6liE1CT+PLlMJDNwSEioC/R1qIB
	UsMs0MsocaZ3N1iNkICtxLG2NhYQm1PATuL306OsILawgLfEvHkrwLaxCKhKfO+9DHYFL1D9
	2qO3WCBsQYkfk++B2cwCWhLrdx5ngrDlJTavecsMsldCQF3i0V9dkLCIgJHEyVMQpzELiEjs
	e/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOBM+k
	dzCuarA4xCjAwajEw9thohcoxJpYVlyZe4hRgoNZSYTXhV8/UIg3JbGyKrUoP76oNCe1+BBj
	MtCjE5mlRJPzgUkqryTe0NjEzMjSyMzCyMTcnDRhJXFexlNPAoQE0hNLUrNTUwtSi2C2MHFw
	SjUw9nnXBD67JtRtpcd/cFk+5063bPn/YrPNSpSOnNB9evXNs7PtXrca+vR/X3q9fJck24NE
	k9tBl/QqNis1TLmcH/WsLrGv9mzVAj7+m0EpFyytP4veMF4nMKHG2rnpeFXZpSvzDM8/dxVb
	vs1Z+AU3C7P8xoqgm8KNtedP277Zd+Fs/sdpb7YcVGIpzkg01GIuKk4EAIq09cNIAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__init/__exit annotations for probe()/remove() are supposed to be
__devinit/__devexit, because __init/__exit for probe()/remove()
are not correct. However, __devinit/__devexit are not used,
because CONFIG_HOTPLUG was removed. Thus, these annotations
should be removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-davinci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index 56b7308..893bfc0 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -478,7 +478,7 @@ static struct rtc_class_ops davinci_rtc_ops = {
 	.set_alarm		= davinci_rtc_set_alarm,
 };
 
-static int __init davinci_rtc_probe(struct platform_device *pdev)
+static int davinci_rtc_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct davinci_rtc *davinci_rtc;
-- 
1.7.2.5



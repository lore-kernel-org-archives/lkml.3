Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbbAELJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:09:08 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39616 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbAELJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:09:07 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-63-54aa70d168a4
Message-id: <1420456143.31776.3.camel@AMDC1943>
Subject: Re: [PATCH] iommu: Fix build of allmod/allyes config on ARMv8
 architecture
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Mon, 05 Jan 2015 12:09:03 +0100
In-reply-to: <20150105110347.GB19590@8bytes.org>
References: <1417787257-10056-1-git-send-email-k.kozlowski@samsung.com>
 <20150105110347.GB19590@8bytes.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xy7oXC1aFGLzpNbLYOGM9q8WC/dYW
	nbM3sFucbXrDbrHp8TVWi8u75rBZzDi/j8li7ZG77A4cHk8OzmPy2Lyk3mPyjeWMHn1bVjF6
	fN4kF8AaxWWTkpqTWZZapG+XwJXR+3YqS8EO1orfnw8xNzCeYOli5OSQEDCR+LPyFiuELSZx
	4d56ti5GLg4hgaWMEl3NkxghnM+MEuuaTrKBVPEK6Ev8W3GbHcQWFgiVuP90HtgkNgFjic3L
	l4DViAgoSVz/3MoK0swssJBJ4t26ZrAiFgFViY0PL4LZnAIGEkv2XmAEsYUEciWmtTYzgdjM
	AuoSk+YtYu5i5AA6SVmisd8NYq+gxI/J91ggSuQlNq95yzyBUWAWko5ZSMpmISlbwMi8ilE0
	tTS5oDgpPddIrzgxt7g0L10vOT93EyMk2L/uYFx6zOoQowAHoxIPr8eJlSFCrIllxZW5hxgl
	OJiVRHhfpa8KEeJNSaysSi3Kjy8qzUktPsTIxMEp1cBoY90UaTFj7aSY0AdcE+P+FkyevHbi
	vGruur1+jyfoKi2sPNZt90Jk/mxBjymfvmVL16myKtobNnatMrgnm+XIvYujhqVMWiRnheaG
	K2n/mR66eojWKdu1anHnzk2yEWD0XZ7V9pXvknj7xKf5Zw32W7xfm2TyJIR/l12F32/Ruv/L
	Xh1tr1ViKc5INNRiLipOBACmKFHIVAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2015-01-05 at 12:03 +0100, Joerg Roedel wrote:
> On Fri, Dec 05, 2014 at 02:47:37PM +0100, Krzysztof Kozlowski wrote:
> >  drivers/iommu/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Applied to iommu/fixes, thanks.

Thanks, but... Few days after my patch Mark Brown posted something
similar:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/310743.html

It was merged by Arnd Bergman and sent to Linus around 3.19-rc1. It is
merged in mainline now:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=20911ce6078fd1503dbf73f761316c66738bf83b

... so my patch can be dropped.

Best regards,
Krzysztof


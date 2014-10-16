Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaJPHje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:39:34 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65309 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaJPHjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:39:33 -0400
X-AuditID: cbfee68e-f79b46d000002b74-38-543f763274a8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Michael Opdenacker'" <michael.opdenacker@free-electrons.com>
Cc: andrew@lunn.ch, ezequiel.garcia@free-electrons.com, dwmw2@infradead.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <543F4CF0.8080404@free-electrons.com>
 <1413435515-12134-1-git-send-email-michael.opdenacker@free-electrons.com>
In-reply-to: <1413435515-12134-1-git-send-email-michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH v2] mtd: orion_nand: fix error code path in probe
Date: Thu, 16 Oct 2014 16:39:30 +0900
Message-id: <000e01cfe914$528cf160$f7a6d420$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/o/d0MC27IRFw1RtCnDAGB/s9gBQAFk6oQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zY12jMvsQg8/7jC3O3z3EbHHkwlpm
	i4krJzNbnD61gNXi8sJLQGLXHDaL3U3L2C0eTFjF5sDh8WTTRUaPnbPusntsXqHlsXlJvcfO
	HZ+ZPPq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj9ovpTAWHuSq+z/rH3MB4jKOLkYNDQsBE
	YtmPnC5GTiBTTOLCvfVsXYxcHEICyxglev4tYIJImEh0fH7HDJGYziixecFtKOcXo8Sq5Z+Z
	QarYBNQkvnw5zA4yVUTAQeL/BxOQMLPAWUaJM//KQGwhgVqJ/2sXgQ3lFIiQmDixixXEFhZw
	ldiw4wE7iM0ioCrRf+QlC4jNK2ArsXnaJGYIW1Dix+R7LBAztSTW7zzOBGHLS2xe85YZ4hl1
	iUd/dSEuMJLob3CAqBCR2PfiHSPIxRICP9klJv58xgKxSkDi2+RDLBCtshKbDjBDvCspcXDF
	DZYJjBKzkCyehWTxLCSLZyFZsYCRZRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGSEz37WC8
	ecD6EKMAB6MSD69GsH2IEGtiWXFl7iFGU6CLJjJLiSbnAxNHXkm8obGZkYWpiamxkbmlmZI4
	b4LUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjGx3nzqFMk85eE79nOu2tT3m4m8tLOpX
	m3nZdctW+lsfWxP85HFI+szJ01vm/584rzpgVbgui9RuoQwhpv+39s59mRvknV37/Iv53r64
	I+b91j8LpC5FFKUtSfUMkD+cdCFR32598Xn5HvvrD189yvgTpyRsKG5m0/xSo1Hp3f+Kh7+/
	bNEIVmIpzkg01GIuKk4EAH6Dp+vkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQV2jMvsQg5PT9S3O3z3EbHHkwlpm
	i4krJzNbnD61gNXi8sJLQGLXHDaL3U3L2C0eTFjF5sDh8WTTRUaPnbPusntsXqHlsXlJvcfO
	HZ+ZPPq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoKCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxu0X
	05kKDnNVfJ/1j7mB8RhHFyMnh4SAiUTH53fMELaYxIV769m6GLk4hASmM0psXnCbGcL5xSix
	avlnsCo2ATWJL18Os3cxcnCICDhI/P9gAhJmFjjLKHHmXxmILSRQK/F/7SImEJtTIEJi4sQu
	VhBbWMBVYsOOB+wgNouAqkT/kZcsIDavgK3E5mmTmCFsQYkfk++xQMzUkli/8zgThC0vsXnN
	W2aQtRIC6hKP/upCXGAk0d/gAFEhIrHvxTvGCYxCs5AMmoVk0Cwkg2YhaVnAyLKKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTIzhlPJPawbiyweIQowAHoxIPr0awfYgQa2JZcWXuIUYJDmYl
	Ed7mQqAQb0piZVVqUX58UWlOavEhRlOgPycyS4km5wPTWV5JvKGxiZmRpZGZhZGJubmSOO+B
	VutAIYH0xJLU7NTUgtQimD4mDk6pBkYvZVnexalRQbWRVx4xCZ9+wFOrwBdcc8L5R8oL45cr
	e0wWlPjrWWmHHlBdYsBWInTumxNPzUXtZ3ekUsueWe0w364g/7r7VvBpv0MNYldP6c76o3+q
	ZIZl//QHBg28t6oS/7Rttma46+Akcaom76OJrspZzucL9z/R286tVCqRqa2fM4FVW4mlOCPR
	UIu5qDgRAGeYJrsvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 16, 2014 1:59 PM, Michael Opdenacker wrote:
> 
> This replaces kzalloc() and ioremap() calls by devm_ functions
> in the probe() routine, which automatically release the corresponding
> resources when probe() fails or when the device is removed.
> 
> This simplifies simplifies the error management code, and brings
> the below improvements or changes:
> 
> A. Fixing a bug reported by "make coccicheck":
> 
> If "board = devm_kzalloc()" fails, the probe() function jumps
> incorrectly to label "no_res" and therefore returns without
> running iounmap().
> 
> B. Requesting the memory region
> 
> Using devm_ioremap_resource() makes the probe() function request
> the corresponding memory region before running ioremap(), as
> it is supposed to do.
> 
> C. Standardizing the error codes:
> 
> The use of devm_ioremap_resource() changes the return value:
>  * -ENOMEM instead of -EIO in case of ioremap() failure,
>  * -EINVAL instead of -ENODEV in case of platform_get_resource()
>    failure.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/mtd/nand/orion_nand.c | 39 +++++++++++----------------------------
>  1 file changed, 11 insertions(+), 28 deletions(-)



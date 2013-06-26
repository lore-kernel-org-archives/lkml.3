Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3FZKov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 06:44:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18781 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3FZKou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 06:44:50 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-32-51cac620e46b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Dan Williams <djbw@fb.com>
Cc: linux-kernel@vger.kernel.org, vinod.koul@intel.com, linux@arm.linux.org.uk,
        dave.jiang@intel.com
Subject: dmaengine_unmap_data patches (was: Re: Re: [PATCH 02/12] dmaengine:
 prepare for generic 'unmap' data)
Date: Wed, 26 Jun 2013 12:44:43 +0200
Message-id: <8491118.DYtx7SOBet@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.5.0-rc2+; KDE/4.8.5; i686; ; )
In-reply-to: <201212061647.51503.b.zolnierkie@samsung.com>
References: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
 <20121206092519.17085.38983.stgit@dev279.prn1.facebook.com>
 <201212061647.51503.b.zolnierkie@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQV2FY6cCDdYeMrE4cbORzWJz/wM2
	i8u75rBZ3L7Ma/Gybz+LA6tHS3MPm8fE5nfsHov3vGTy+LxJLoAlissmJTUnsyy1SN8ugStj
	6yHpgqOcFafWXWRtYLzL3sXIySEhYCKxuekXG4QtJnHh3nowW0hgOqPEj/nRXYxcQHYLk8Sy
	vk/MIAk2ASuJie2rGEFsEQE5idW3p4DFmQXSJF48nw8WFxYokLg1pZ0JxGYRUJXYdamDBcTm
	FdCU6Jo0EywuKmAvse3dW7BlnEAzr756wAaxbCujRMemv0wQDYISPybfY4FYIC+xb/9UVghb
	S2L9zuNMExgFZiEpm4WkbBaSsgWMzKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgoP4mdQO
	xpUNFocYBTgYlXh4FbaeDBRiTSwrrsw9xCjBwawkwvtm/qlAId6UxMqq1KL8+KLSnNTiQ4zS
	HCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJMHJxSDYzcq3JFlvK9/GkWsUAxzvdc6ZzE8iTeYPcr
	051/Sze+7v7wLzet4OFk+QXXXRstX0744Jvm+Mdi+oy1/Ww2iit+7/C5elXfd0XeSWlDEbvZ
	7JsZI/cI6fZIpaV/eN+y9tjesDsxhfpZr9+qv1jwyNx803S5DJYDV5sN1+h8kdK8/bd0MXOZ
	kLESS3FGoqEWc1FxIgDXFylrXgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The original discussion is here:

	https://lkml.org/lkml/2012/12/6/71

Unfortunately there hasn't been any progress on these patches since
last December.  Dan, if you lack time to polish and push them would
you like me to take them over?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Thursday, December 06, 2012 04:47:51 PM Bartlomiej Zolnierkiewicz wrote:
> On Thursday 06 December 2012 10:25:20 Dan Williams wrote:
> > Add a hook for a common dma unmap implementation to enable removal of
> > the per driver custom unmap code.  (A reworked version of Bartlomiej
> > Zolnierkiewicz's patches to remove the custom callbacks and the size
> > increase of dma_async_tx_descriptor for drivers that don't care about raid).
> > 
> > Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Signed-off-by: Dan Williams <djbw@fb.com>
> 
> Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> 
> Thanks for reworking my patches!  The patchset looks generally
> good but there are few issues that should be fixed (please see
> other mails).
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung Poland R&D Center


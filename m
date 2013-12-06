Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab3LFMED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:04:03 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62686 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670Ab3LFMEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:04:00 -0500
X-AuditID: cbfee61a-b7f796d000004313-0a-52a1bd2e6501
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 0/2] usb: s3c-hsotg: fixes for maxpacket and TX FIFO handling
Date: Fri, 06 Dec 2013 13:03:43 +0100
Message-id: <1386331425-16594-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsVy+t9jAV29vQuDDK702VjMetnOYrFxxnpW
	i4P36y2aF69ns7i8aw6bxaJlrcwWa4/cZbd4cHgnuwOHx/65a9g9+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGT1TXzAWHGapeLhgKVMD42XmLkZODgkBE4nT/zYyQthiEhfurWcD
	sYUEFjFK/LwW0cXIBWS3M0n8bj0IVsQmoCOx5fsEMFtEQEBi/YtL7CBFzAIXGCXeL1jHDpIQ
	FvCVuDRhKQuIzSKgKvHu/EtWEJtXwFVi09rzTF2MHEDbFCTmTLKZwMi9gJFhFaNoakFyQXFS
	eq6hXnFibnFpXrpecn7uJkZwiDyT2sG4ssHiEKMAB6MSDy/HqgVBQqyJZcWVuYcYJTiYlUR4
	bZYvDBLiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6DVOlBIID2xJDU7NbUgtQgmy8TBKdXAWPOw
	rdepcJP4tnn2m99dtg+Yc2fHI5FFvz/Pipp/+9TVhF9Xthff+SadxWFXsp79hn0Tw04XYbvD
	Csuqjnu726o8r1rJwxpwUILnVEB+kuTZL2lWCnM7GwOyKmu+XPqmXrFC/UxRzaPbf2w823/d
	dmV0F92/fPMbM7Nf93p3Fi0wvW/B9/LPPiWW4oxEQy3mouJEACGy31UNAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patches contains fixes for s3c-hsotg driver. They fix maxpacket sizes set
in s3c_hsotg_irq_enumdone() function, and adds flushing TX FIFO when killing all
requests in dedicated-fifo mode. More info in commit messages.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Robert Baldyga (2):
  USB: gadget: s3c-hsotg: fix maxpacket size in s3c_hsotg_irq_enumdone
  USB: gadget: s3c-hsotg: add flush TX FIFO when kill all requests

 drivers/usb/gadget/s3c-hsotg.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
1.7.9.5


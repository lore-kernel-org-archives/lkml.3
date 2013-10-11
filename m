Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab3JKKta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:49:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9717 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757784Ab3JKKt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:49:27 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-a8-5257d7b50e15
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] USB: gadget: s3c-hsotg: remove unused label
Date: Fri, 11 Oct 2013 12:48:51 +0200
Message-id: <1381488531-29638-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42I5/e+xoO7W6+FBBiteWlvMetnOYrFxxnpW
	i4P36y2aF69nszjb9Ibd4vKuOWwWi5a1MlusPXKX3eLB4Z3sDpwe++euYffo27KK0eP4je1M
	Hp83yQWwRHHZpKTmZJalFunbJXBldM/4xV4wj7Xi1dLlzA2M21i6GDk5JARMJFqvX2GFsMUk
	Ltxbz9bFyMUhJDCdUWLvURinnUniwOUHbCBVbAI6Elu+T2AEsUUEBCTWv7jEDlLELPCXUeL2
	w06wImEBG4lDDX1gK1gEVCU+7nrEBGLzCrhKPFnSwNzFyAG0TkFiziSbCYzcCxgZVjGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIEh8sz6R2MqxosDjEKcDAq8fBaMIQHCbEmlhVX5h5ilOBg
	VhLhFTwJFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cC4
	dkIug8e6rEs2M//J2vYutLjJ93Z+rHH4i8UvlBQUPizS2a8SeeGs49qD6VmK8efsWIv82uSf
	bj0atit6V1etwNbvCzcs3/3IZk4pq3x75d59Zaos53x2Hw955fqt5YPv71knb3GzHfDbxFoj
	JW+f0fN7SvPqj92rf99N2+4RJVCR8u+qQsZ7JZbijERDLeai4kQAAZMZnBMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unused label.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index a955e6e..0646587 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2712,7 +2712,6 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	/* enable the endpoint interrupt */
 	s3c_hsotg_ctrl_epint(hsotg, index, dir_in, 1);
 
-out:
 	spin_unlock_irqrestore(&hsotg->lock, flags);
 	return ret;
 }
-- 
1.7.9.5


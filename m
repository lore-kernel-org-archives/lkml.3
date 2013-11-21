Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab3KUMt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:49:56 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50959 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3KUMty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:49:54 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-4b-528e0171724e
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 0/2] usb: s3c-hsotg: disconnect handling and spinlock bugfixes
Date: Thu, 21 Nov 2013 13:49:16 +0100
Message-id: <1385038158-20151-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsVy+t9jQd1Cxr4gg+2ruS1mvWxnsdg4Yz2r
	xcH79RbNi9ezWVzeNYfNYtGyVmaLtUfusls8OLyT3YHDY//cNewefVtWMXocv7GdyePzJrkA
	ligum5TUnMyy1CJ9uwSujNP7elkLjjBXNCw+xtLA+IKpi5GTQ0LAROLVjnXMELaYxIV769m6
	GLk4hASmM0o0d25mhXDamSRWHZkHVsUmoCOx5fsERhBbREBAYv2LS+wgRcwCFxgl3i9Yxw6S
	EBbwk1hzbQsLiM0ioCqxfs4asAZeAVeJO6uPAK3mAFqnIDFnks0ERu4FjAyrGEVTC5ILipPS
	c430ihNzi0vz0vWS83M3MYKD5Jn0DsZVDRaHGAU4GJV4eB887QkSYk0sK67MPcQowcGsJMIb
	+bE3SIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVAPjVK3Z
	lVcnuDR3L5VieXPg++wQ2d65Bi+NVS5crlT02sy21jHKdOXjmhVLbJMrN4qny198dHGztOrp
	+l8af/JTrprlGzt3Ljugm+38P0FC3r9huT3Dzbvq85Unqk05aWsda/1nzYqc5Cbpuj7tPxZ2
	2kt28n8tv3LSmZ3ruu/JnAq2R/WyOxYpsRRnJBpqMRcVJwIAsAktbw4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
This two patches contains bugfixes for s3x-hsotg driver. They fix disconnect
event handling, and add few missing spin lock and unlock calls.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Robert Baldyga (2):
  USB: gadget: s3c-hsotg: fix spinlock locking
  USB: gadget: s3c-hsotg: fix disconnect handling

 drivers/usb/gadget/s3c-hsotg.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

-- 
1.7.9.5


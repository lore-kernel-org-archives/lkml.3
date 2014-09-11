Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaIKM5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:57:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61577 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424AbaIKMxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:53:48 -0400
X-AuditID: cbfee61b-f79f86d00000144c-d7-54119b5a7cd8
From: Robert Baldyga <r.baldyga@samsung.com>
To: paulz@synopsys.com
Cc: gregkh@linuxfoundation.org, dinguyen@opensource.altera.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 0/2] usb: dwc2: Revert patches causing problems
Date: Thu, 11 Sep 2014 14:53:29 +0200
Message-id: <1410440011-9106-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkluLIzCtJLcpLzFFi42I5/e+xgG70bMEQg93nWCw2zljParHq0xpm
	i+bF69ksLu+aw2axaFkrs8XaI3fZLbZPmc5k8eDwTnYHDo/9c9ewe/Rfm8Tu0bdlFaPHlv2f
	GT0+b5ILYI3isklJzcksSy3St0vgyjjZOZO54CRLxdL3/awNjLeZuxg5OSQETCQ+zm5ggrDF
	JC7cW8/WxcjFISSwiFHiwoHLzBBOO5PE+UN3GEGq2AR0JLZ8nwBkc3CIAHV8/8AJUsMscJNR
	Yv7ySewgNcIC9hI//u8Em8oioCox+ccOsDivgIvE3o4bbBDb5CROHpvMOoGRewEjwypG0dSC
	5ILipPRcI73ixNzi0rx0veT83E2M4IB5Jr2DcVWDxSFGAQ5GJR7eShbBECHWxLLiytxDjBIc
	zEoivDemA4V4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUw
	enStYVuWnRVS+mHlq1wzx+1bjx1eG7R0seqitVNWrD0qsLK7/FPI6RbO9wK9l9XKbF+UTBAw
	/dRa9u+IlUcrM/ul2nnRhawOB08/3emz7tptOyUrFxamt5dV/Dh2poVVT+aOYbybdc29qffg
	Mu4MHs29AbfvL5Nc+v2Evv/fQ7ZBWcca56QWKLEUZyQaajEXFScCAPBFOe0UAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches breaks dwc2 driver. The first one causes build break,
the second breaks gadget at Samsung platforms.

Best regards
Robert Baldyga

Robert Baldyga (2):
  Revert "usb: dwc2: Update Kconfig to support dual-role"
  Revert "usb: dwc2: move "samsung,s3c6400-hsotg" into common platform"

 drivers/usb/dwc2/Kconfig    | 63 +++++++++++++++++++--------------------------
 drivers/usb/dwc2/Makefile   | 21 +++++++--------
 drivers/usb/dwc2/gadget.c   |  1 +
 drivers/usb/dwc2/platform.c |  1 -
 4 files changed, 38 insertions(+), 48 deletions(-)

-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbbAEJb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:31:56 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:57606 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbAEJby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:31:54 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-97-54aa5a07fc2c
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com, paulz@synopsys.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 0/2] usb: dwc2: fix the uncompleted requests problem
Date: Mon, 05 Jan 2015 10:31:33 +0100
Message-id: <1420450295-25818-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t9jAV2OqFUhBptvslkcvF9v0bx4PZvF
	5V1z2CwWLWtlttg+ZTqTxYPDO9kd2Dz2z13D7tG3ZRWjx5b9nxk9jt/YzuTxeZNcAGsUl01K
	ak5mWWqRvl0CV8a+U6fZC7awVDy+d5+tgfEUcxcjJ4eEgInEifULGSFsMYkL99azdTFycQgJ
	LGKUeLxsMiuE084k8ebdBTaQKjYBHYkt3yeAdYgIqEhcfD6dBaSIWaCRUeLH7xmsIAlhAReJ
	xxeega1gEVCV2HTlOBOIzSvgKnF/wV6o1XISJ49NZp3AyL2AkWEVo2hqQXJBcVJ6rpFecWJu
	cWleul5yfu4mRnBwPJPewbiqweIQowAHoxIPr8eJlSFCrIllxZW5hxglOJiVRHjX3QIK8aYk
	VlalFuXHF5XmpBYfYpTmYFES51WybwsREkhPLEnNTk0tSC2CyTJxcEo1MPbm/i8olX7q90bd
	XzFIdcfViXsSgoV2M52Ja+RgbNmhOkche5G7/EtTbz6xfQ2n+K5dTVyg5JFxpFTo5MwCkevL
	vvo9vCFY9/liannuyTvVfN/r9l3kmua8/POpTe9d/Nes//mTXYZjXVDAYWO5y7yhR+Ve2K6d
	Li7HW3bgSU9S5NQD3YpeR5RYijMSDbWYi4oTAXvIrU0KAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

I prepared this patchset in response to our discussion:
https://lkml.org/lkml/2014/12/29/193

It reverts of unproper patch and adds working solution of the problem
described in commit messages.

Best regards,
Robert Baldyga

Robert Baldyga (2):
  Revert "usb: dwc2: gadget: kill requests with 'force' in
    s3c_hsotg_udc_stop()"
  drivers: usb: dwc2: remove 'force' parameter from kill_all_requests()

 drivers/usb/dwc2/gadget.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

-- 
1.9.1


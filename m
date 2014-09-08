Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaIHH5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 03:57:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63621 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbaIHH5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 03:57:19 -0400
X-AuditID: cbfee61a-f79e46d00000134f-0a-540d615d432a
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH RESEND v7 0/2] usb: gadget: f_fs: userspace API fixes and
 improvements
Date: Mon, 08 Sep 2014 09:56:58 +0200
Message-id: <1410163020-13910-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLJMWRmVeSWpSXmKPExsVy+t9jQd3YRN4Qg74T8hYH79dbNC9ez2Zx
	edccNotFy1qZLR4c3snuwOqxf+4ado++LasYPY7f2M7k8XmTXABLFJdNSmpOZllqkb5dAlfG
	/fYtTAXPmSsOb1jB3MDYzdzFyMkhIWAice/XOUYIW0ziwr31bF2MXBxCAtMZJfac2coC4bQz
	SexeMJkdpIpNQEdiy/cJYB0iAgIS619cYgcpYhZoZJT48XsGK0hCWCBCYsv0V2ArWARUJWZs
	nMoGYvMKuEps2fQJarWcxMljk1knMHIvYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc
	CM+kdjCubLA4xCjAwajEw8txmSdEiDWxrLgy9xCjBAezkggvQxhviBBvSmJlVWpRfnxRaU5q
	8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQbGpTPTVf5v5nc7EvcsSu+Z8d7ayyEy
	EjMl1KfkWwuHPNT5kXH9SPBFjl1KM0seF/benLxez2iN6ZS2qz9YfnX+Wtf31MBdovwPu88f
	Odkz2SVVs49knO292xjx1mZyGVvQridrTrWfPHVz74Id9vVr2ScWSyldOCrK1yyw0KRW7nBH
	lduSpeELlViKMxINtZiLihMBreNgTgACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

I have rebased this patchset at your testing/next/ branch.

Best regards
Robert Baldyga

Robert Baldyga (2):
  usb: gadget: f_fs: add ioctl returning ep descriptor
  usb: gadget: f_fs: virtual endpoint address mapping

 drivers/usb/gadget/function/f_fs.c  | 46 +++++++++++++++++++++++++++++++++++--
 drivers/usb/gadget/function/u_fs.h  |  2 ++
 include/uapi/linux/usb/functionfs.h |  7 ++++++
 3 files changed, 53 insertions(+), 2 deletions(-)

-- 
1.9.1


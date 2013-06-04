Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab3FDNh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:37:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43771 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3FDNhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:37:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH] blkback/blkfront patches for v3.11
Date: Tue,  4 Jun 2013 09:37:41 -0400
Message-Id: <1370353063-13033-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two little fixes for the stable/for-jens-3.10 tree.

One is an addition of the 'max' parameter to the xen-blkfront to alter the
amount of indirect descriptor segments that frontend will try to negotiate.

The other is a fix and moving the parameters for xen-blkback to the
testing directory and also appropiately named file.


 Documentation/ABI/stable/sysfs-bus-xen-backend      | 18 ------------------
 Documentation/ABI/testing/sysfs-driver-xen-blkback  | 17 +++++++++++++++++
 Documentation/ABI/testing/sysfs-driver-xen-blkfront | 10 ++++++++++
 drivers/block/xen-blkfront.c                        |  2 ++
 4 files changed, 29 insertions(+), 18 deletions(-)


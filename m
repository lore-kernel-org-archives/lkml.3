Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab3AYRcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:32:46 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32383 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab3AYRco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:32:44 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH] block backend fixes for v3.8 (and stable) v1.
Date: Fri, 25 Jan 2013 12:32:29 -0500
Message-Id: <1359135152-30688-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three little fixes to make the block backend by a bit smarter when
dealing with frontends that put bogus data on the ring.

 drivers/block/xen-blkback/blkback.c | 12 +++++++++---
 drivers/block/xen-blkback/common.h  |  2 ++
 drivers/block/xen-blkback/xenbus.c  |  2 ++
 include/xen/interface/io/ring.h     |  6 ++++++
 4 files changed, 19 insertions(+), 3 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3FQTrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 15:47:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19172 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3FQTro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:47:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jbeulich@suse.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Block backend fixes for insane request (v6).
Date: Mon, 17 Jun 2013 15:47:32 -0400
Message-Id: <1371498454-2116-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heya,

This patchset is a rework of the patchset that Jan backported in 2.6.18.

 drivers/block/xen-blkback/blkback.c | 13 ++++++++++++-
 drivers/block/xen-blkback/common.h  |  2 ++
 drivers/block/xen-blkback/xenbus.c  |  2 ++
 include/xen/interface/io/ring.h     |  5 +++++
 
Jan Beulich (1):
      xen/io/ring.h: new macro to detect whether there are too many requests on the ring

Konrad Rzeszutek Wilk (1):
      xen/blkback: Check for insane amounts of request on the ring (v6).


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3FAELh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 00:11:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50132 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750821Ab3FAELc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 00:11:32 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/8] pktcdvd: More neatenings
Date: Fri, 31 May 2013 21:11:21 -0700
Message-Id: <cover.1370048648.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <1369978679.10556.36.camel@joe-AO722>
References: <1369978679.10556.36.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the compile error the patch 1 and compile fix in 2
Added Andy's suggestion in patch 2.
Added conversions to print pd->name in logging macros.

Joe Perches (8):
  pktcdvd: Convert ZONE macro to static function get_zone()
  pktcdvd: Convert printk to pr_<level>
  pktcdvd: Consolidate DPRINTK and VPRINTK macros
  pktcdvd: Add struct pktcdvd_device * to pkt_dbg
  pktcdvd: Add struct pktcdvd_device.name to pr_err logging where possible
  pktcdvd: Convert pr_notice to pkt_notice
  pktcdvd: Convert pr_info to pkt_info
  pktcdvd: Add struct pktcdvd_device * to pkt_dump_sense()

 drivers/block/pktcdvd.c | 277 ++++++++++++++++++++++++------------------------
 1 file changed, 140 insertions(+), 137 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


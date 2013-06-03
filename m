Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288Ab3FCQpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:45:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52844 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758785Ab3FCQpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:45:44 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 0/8] pktcdvd: More neatenings
Date: Mon,  3 Jun 2013 09:45:33 -0700
Message-Id: <cover.1370276576.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <20130603125057.GB23987@mwanda>
References: <20130603125057.GB23987@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the oversight reviews guys.

V3:
Fixed patch 2 thinko in sense_string via Dan Carpenter
Moved pr_err in patch 5 to avoid moving again in patch 6 via Andy Schevchenko

V2:
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

 drivers/block/pktcdvd.c | 278 ++++++++++++++++++++++++------------------------
 1 file changed, 140 insertions(+), 138 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


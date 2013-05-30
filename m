Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab3E3U6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:58:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43849 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756251Ab3E3U5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:57:53 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] pktcdvd: A few more neatenings
Date: Thu, 30 May 2013 13:57:48 -0700
Message-Id: <cover.1369947186.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <alpine.LNX.2.00.1305291537120.30576@pobox.suse.cz>
References: <alpine.LNX.2.00.1305291537120.30576@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (3):
  pktcdvd: Convert ZONE macro to static function get_zone()
  pktcdvd: Convert printk to pr_<level>
  pktcdvd: Consolidate DPRINTK and VPRINTK macros

 drivers/block/pktcdvd.c | 248 ++++++++++++++++++++++++------------------------
 1 file changed, 126 insertions(+), 122 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


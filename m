Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3G3KvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:51:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab3G3KvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 06:51:08 -0400
Date: Tue, 30 Jul 2013 12:51:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] pktcdvd
Message-ID: <alpine.LNX.2.00.1307301238400.18809@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

please consider pulling from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block.git for-3.12/pktcdvd

to receive a few small cleanups to pktcdvd driver by Joe Perches. Nothing 
urgent, definitely 3.12 material.

Thanks.

Joe Perches (8):
      pktcdvd: convert ZONE macro to static function get_zone()
      pktcdvd: convert printk to pr_<level>
      pktcdvd: consolidate DPRINTK and VPRINTK macros
      pktcdvd: add struct pktcdvd_device * to pkt_dbg
      pktcdvd: add struct pktcdvd_device.name to pr_err logging where possible
      pktcdvd: convert pr_notice to pkt_notice
      pktcdvd: convert pr_info to pkt_info
      pktcdvd: add struct pktcdvd_device * to pkt_dump_sense()

 drivers/block/pktcdvd.c |  278 ++++++++++++++++++++++++-----------------------
 1 files changed, 140 insertions(+), 138 deletions(-)

-- 
Jiri Kosina
SUSE Labs

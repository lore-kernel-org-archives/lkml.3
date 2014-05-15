Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaEORJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:09:03 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:32968 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614AbaEORJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:09:02 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvRkAEf0dFNXQwiB/2dsb2JhbABZgwaBYQVbfahaBAEBAQEBAQUBmhkCAoERF3SCZhwjGIECJIhYAdEphVSIeoRHAQOZUAGTFIM4Ow
Date: Thu, 15 May 2014 19:08:58 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: [PATCH 0/3] HPFS logging clean-up
Message-Id: <20140515190858.10661f614e06e045b11b1616@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patchset converts HPFS to current logging functions.

Fabian Frederick (3):
  FS/HPFS: convert printk to pr_foo()
  FS/HPFS: use pr_fmt for logging
  FS/HPFS: use __func__ for logging

 fs/hpfs/alloc.c   |  2 +-
 fs/hpfs/buffer.c  | 12 ++++++------
 fs/hpfs/dir.c     |  6 +++---
 fs/hpfs/dnode.c   | 44 ++++++++++++++++++++++++++------------------
 fs/hpfs/ea.c      |  6 +++---
 fs/hpfs/hpfs_fn.h |  5 +++++
 fs/hpfs/inode.c   |  3 ++-
 fs/hpfs/map.c     | 17 ++++++++++-------
 fs/hpfs/name.c    | 11 ++++++-----
 fs/hpfs/namei.c   |  2 +-
 fs/hpfs/super.c   | 55 ++++++++++++++++++++++++++++++++-----------------------
 11 files changed, 95 insertions(+), 68 deletions(-)

-- 
1.8.4.5


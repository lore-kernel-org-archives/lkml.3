Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaGBUsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:48:41 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:7611 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbaGBUsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:48:40 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4IANBvtFNXQBPR/2dsb2JhbABagw2saQUBAQEBAQEFAW4BmWeBBxd1hGAjgRqIfQHHe4VwiTIdhC0Fmm2UCoNFOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, sasha.levin@oracle.com, akpm@linux-foundation.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 0/4] CRAMFS Logging clean-up
Date: Wed,  2 Jul 2014 22:47:11 +0200
Message-Id: <1404334035-7027-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patchset converts CRAMFS to current logging functions and
fixes some checkpatch warnings.

Fabian Frederick (4):
  FS/CRAMFS: convert printk to pr_foo()
  FS/CRAMFS: use pr_fmt
  FS/CRAMFS: code clean-up
  fs/cramfs/inode.c: use linux/uaccess.h

 fs/cramfs/inode.c      | 45 +++++++++++++++++++++++++--------------------
 fs/cramfs/uncompress.c | 10 ++++++----
 2 files changed, 31 insertions(+), 24 deletions(-)

-- 
1.8.4.5


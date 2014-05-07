Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbaEGPvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:51:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46567 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933875AbaEGPvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:51:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.23
Date: Wed,  7 May 2014 08:51:41 -0700
Message-Id: <1399477902-6798-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.23 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.22 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Makefile                                |  2 +-
 drivers/block/floppy.c                  | 11 +++++++----
 drivers/tty/n_tty.c                     |  4 ++++
 net/netfilter/nf_conntrack_proto_dccp.c |  6 +++---
 4 files changed, 15 insertions(+), 8 deletions(-)

Daniel Borkmann (1):
      netfilter: nf_conntrack_dccp: fix skb_header_pointer API usages

Kamal Mostafa (1):
      Linux 3.8.13.23

Matthew Daley (2):
      floppy: ignore kernel-only members in FDRAWCMD ioctl input
      floppy: don't write kernel-only members to FDRAWCMD ioctl output

Peter Hurley (1):
      n_tty: Fix n_tty_write crash when echoing in raw mode


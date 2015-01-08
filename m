Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbbAHSlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:41:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517AbbAHSlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:41:49 -0500
Date: Thu, 8 Jan 2015 10:41:46 -0800 (PST)
From: Sage Weil <sweil@redhat.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for -rc4
Message-ID: <alpine.DEB.2.00.1501081040050.3041@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client for-linus

These are both pretty trivial: a sparse warning fix and size_t printk 
thing.

Thanks!
sage

----------------------------------------------------------------
Ilya Dryomov (2):
      ceph: use %zu for len in ceph_fill_inline_data()
      libceph: fix sparse endianness warnings

 fs/ceph/addr.c                  | 2 +-
 include/linux/ceph/osd_client.h | 4 ++--
 net/ceph/auth_x.c               | 2 +-
 net/ceph/mon_client.c           | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

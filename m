Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3FDOHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:07:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab3FDOHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:13 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (fixes)
Date: Tue,  4 Jun 2013 14:40:36 +0100
Message-Id: <1370353240-5962-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are four patches this time. The first fixes a problem where the
wrong descriptor type was being written into the log for journaled data
blocks. The second fixes a race relating to the deallocation of allocator
data. The third provides a fallback if kmalloc is unable to satisfy a
request to allocate a directory hash table. The fourth fixes the iopen
glock caching so that inodes are deleted in a more timely manner after
rmdir/unlink,

Steve.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaDAJP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:15:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaDAJP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:15:56 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Tue,  1 Apr 2014 10:15:12 +0100
Message-Id: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the current content of the GFS2 -nmw tree for the
current merge window.

One of the main highlights this time, is not the patches themselves
but instead the widening contributor base. It is good to see that
interest is increasing in GFS2, and I'd like to thank all the
contributors to this patch set.

In addition to the usual set of bug fixes and clean ups, there are
patches to improve inode creation performance when xattrs are required
and some improvements to the transaction code which is intended to help
improve scalability after further changes in due course. Journal extent
mapping is also updated to make it more efficient and again, this is a
foundation for future work in this area.

The maximum number of ACLs has been increased to 300 (for a 4k block size)
which means that even with a few additional xattrs from selinux,
everything should fit within a single fs block. There is also a patch
to bring GFS2's own copy of the writepages code up to the same level as
the core VFS. Eventually we may be able to merge some of this code, since
it is fairly similar.

The other major change this time, is bringing consistency to the printing
of messages via fs_<level>, pr_<level> macros. 

Steve.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab3BSKeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:34:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932568Ab3BSKeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:34:00 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Tue, 19 Feb 2013 10:07:30 +0000
Message-Id: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is one of the smallest collections of patches for the merge
window for some time. There are some clean ups relating to the
transaction code and the shrinker, which are mostly in preparation
for further development, but also make the code much easier to
follow in these areas.

There is a patch which allows the use of ->writepages even in the
default ordered write mode for all writebacks. This results in
sending larger i/os to the block layer, and a subsequent increase
in performance. It also reduces the number of different i/o paths
by one.

There is also a bug fix reinstating the withdraw ack system which
somehow got lost when the lock modules were merged into GFS2.

And thats all this time around,

Steve.


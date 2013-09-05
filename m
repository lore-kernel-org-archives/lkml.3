Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935558Ab3IEJ2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:28:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763411Ab3IEJ2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:28:40 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2 Pre-pull patch posting (merge window)
Date: Thu,  5 Sep 2013 10:02:06 +0100
Message-Id: <1378371732-3947-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the smallest merge window patch set for GFS2 for quite
some time. Only one of the patches (moving gfs2_sync_meta) is
a non-bug fix patch, although the merge ordered and writeback
writepage patch is also a nice clean up.

A couple of the patches are quite recently added, due to my only
having recently returned from holiday, so I'll give them a couple
of extra days in -next before sending the pull request.

Steve.


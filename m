Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaATMYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:24:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbaATMYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:03 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Mon, 20 Jan 2014 12:23:23 +0000
Message-Id: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are the pending patches for the merge window which are currently
in the GFS2 tree.

The main topics this time are allocation, in the form of Bob's
improvements when searching resource groups and several updates
to quotas which should increase scalability. The quota changes
follow on from those in the last merge window, and there will
likely be further work to come in this area in due course.

There are also a few patches which help to improve efficiency
of adding entries into directories, and clean up some of that
code.

One on-disk change is included this time, which is to write some
additional information which should be useful to fsck and
also potentially for debugging.

Other than that, its just a few small random bug fixes and
clean ups,

Steve.


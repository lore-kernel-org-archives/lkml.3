Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab3DZJpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:45:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab3DZJpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:45:43 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Fri, 26 Apr 2013 10:18:53 +0100
Message-Id: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since the merge window is coming up soon, I'm posting the content of
the GFS2 -nmw tree as usual. There is not a whole lot of change this
time - there are some further changes which are in the works, but those
will be held over until next time.

Here there are some clean ups to inode creation, the addition of an
origin (local or remote) indicator to glock demote requests, removal
of one of the remaining GFP_NOFAIL allocations during log flushes,
one minor clean up, and a one liner bug fix,

Steve.


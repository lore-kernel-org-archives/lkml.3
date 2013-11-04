Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab3KDLgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:36:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab3KDLgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:13 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Mon,  4 Nov 2013 11:09:23 +0000
Message-Id: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm just back from firstly Edinburgh, and secondly holiday, and the
merge window is again upon us. I've added in the three pending patches
which were under test while I was away and then that should be it for
this time.

The main feature of interest this time is quota updates. There are
some clean ups and some patches to use the new generic lru list
code. There is still plenty of scope for some further changes in
due course - faster lookups of quota structures is very much
on the todo list. Also, a start has been made towards the more tricky
issue of using the generic lru code with glocks, but that will
have to be completed in a subsequent merge window.

The other, more minor feature, is that there have been a number of
performance patches which relate to block allocation. In particular
they will improve performance when the disk is nearly full,

Steve.


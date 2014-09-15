Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaIOJdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:33:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbaIOJdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:33:05 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (fixes)
Date: Mon, 15 Sep 2014 10:32:42 +0100
Message-Id: <1410773568-1573-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are a number of small fixes for GFS2. There is a fix for FIEMAP
on large sparse files, a negative dentry hashing fix, a fix for
flock, and a bug fix relating to d_splice_alias usage. There are
also (patches 1 and 5) a couple of updates which are less
critical, but small and low risk.

Steve.


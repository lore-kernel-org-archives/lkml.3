Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab3HSJOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:14:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab3HSJOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:14:38 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (fixes)
Date: Mon, 19 Aug 2013 09:48:02 +0100
Message-Id: <1376902087-7783-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Out of these fives patches, the one for ensuring that the number of
revokes is not exceeded, and the one for checking the glock is not
already held in gfs2_getxattr are the two most important. The latter
can be triggered by selinux.

The other three patches are very small and fix mostly fairly
trivial issues,

Steve.


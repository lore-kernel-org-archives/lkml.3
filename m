Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3EXOEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:04:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935Ab3EXOEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:04:08 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (fixes)
Date: Fri, 24 May 2013 14:37:31 +0100
Message-Id: <1369402655-26600-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This time there are just four fixes. There are a couple of minor updates
to the quota code, a fix for KConfig to ensure that only valid combinations
including GFS2 can be built, and a fix for a typo affecting end i/o
processing when writing the journal.

Also, there is a temporary fix for a performance regression relating to
block reservations and directories. A longer fix will be applied in
due course, but this deals with the most immediate problem for now,

Steve.



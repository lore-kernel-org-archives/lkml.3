Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbbATPcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:32:10 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:48641 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbbATPcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:32:08 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        Greg Thelen <gthelen@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/2] mm: memcontrol: default hierarchy interface for memory v2
Date: Tue, 20 Jan 2015 10:31:53 -0500
Message-Id: <1421767915-14232-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

these patches changed sufficiently while in -mm that a rebase makes
sense.  The change from using "none" in the configuration files to
"max"/"infinity" requires a do-over of 1/2 and a changelog fix in 2/2.

I folded all increments, both in-tree and the ones still pending, and
credited your seq_puts() checkpatch fix, so these two changes are the
all-encompassing latest versions, and everything else can be dropped.

Thanks!


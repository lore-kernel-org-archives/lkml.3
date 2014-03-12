Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbaCLB2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:28:46 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33929 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183AbaCLB2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:28:45 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/8] memcg: charge path cleanups
Date: Tue, 11 Mar 2014 21:28:26 -0400
Message-Id: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

here are some cleanups and refactoring efforts of the memcg charge
path for 3.15 from Michal and me.

 mm/memcontrol.c | 319 +++++++++++++++++++-----------------------------------
 1 file changed, 112 insertions(+), 207 deletions(-)


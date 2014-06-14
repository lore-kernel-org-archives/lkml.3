Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaFNTkG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 15:40:06 -0400
Received: from shelob.surriel.com ([74.92.59.67]:45545 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaFNTkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 15:40:04 -0400
X-Greylist: delayed 1172 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jun 2014 15:40:04 EDT
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@kernel.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: [PATCH 0/3] sched,numa: further numa balancing fixes
Date: Sat, 14 Jun 2014 15:18:56 -0400
Message-Id: <1402773539-6466-1-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few more bug fixes that seem to improve convergence of
"perf bench numa mem -m -0 -P 1000 -p X -t Y" for various
values of X and Y, on both 4 and 8 node systems.

This does not address the issue I highlighted Friday:

https://lkml.org/lkml/2014/6/13/529

I have an idea on how to fix that issue, but implementing
that as part of this series would be silly, since I would
have to rip the code back out and completely rewrite it
once I started working on placement for systems with complex
NUMA topologies. Better to leave that code for then...

Patches are against the latest -next and -tip trees.


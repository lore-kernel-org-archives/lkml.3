Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbaGNNVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:21:55 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33883 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbaGNNVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:21:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 0/3] mm: vmscan: followup fixes to cleanups in -mm
Date: Mon, 14 Jul 2014 09:20:46 -0400
Message-Id: <1405344049-19868-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

here is a follow-up to feedback on patches you already have in -mm.
This series is not linear: the first two patches are fixlets according
to their name, the third one could be placed after "mm: vmscan: move
swappiness out of scan_control".

Thanks!


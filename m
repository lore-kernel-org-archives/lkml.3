Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbaBGUrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 15:47:18 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39687 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaBGUrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 15:47:17 -0500
Date: Fri, 7 Feb 2014 12:47:15 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rashika Kheria <rashika.kheria@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, josh@joshtriplett.org
Subject: Re: [PATCH 2/9] mm: Mark functions as static in memory.c
In-Reply-To: <2bd9a806eae6958a75de452ba1d09f5cb6e2f7bc.1391167128.git.rashika.kheria@gmail.com>
Message-ID: <alpine.DEB.2.02.1402071246351.4212@chino.kir.corp.google.com>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com> <2bd9a806eae6958a75de452ba1d09f5cb6e2f7bc.1391167128.git.rashika.kheria@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1120541338-1391806036=:4212"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1120541338-1391806036=:4212
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 7 Feb 2014, Rashika Kheria wrote:

> Mark functions as static in memory.c because they are not used outside
> this file.
> 
> This eliminates the following warnings in mm/memory.c:
> mm/memory.c:3530:5: warning: no previous prototype for ‘numa_migrate_prep’ [-Wmissing-prototypes]
> mm/memory.c:3545:5: warning: no previous prototype for ‘do_numa_page’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: David Rientjes <rientjes@google.com>
--531381512-1120541338-1391806036=:4212--

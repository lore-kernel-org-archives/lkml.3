Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaBGUt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 15:49:57 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:38971 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaBGUtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 15:49:55 -0500
Date: Fri, 7 Feb 2014 12:49:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rashika Kheria <rashika.kheria@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Ingo Molnar <mingo@kernel.org>, linux-mm@kvack.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 5/9] mm: Mark functions as static in migrate.c
In-Reply-To: <2f62d7bb34ad1797b2990524239d4de90f8073a4.1391167128.git.rashika.kheria@gmail.com>
Message-ID: <alpine.DEB.2.02.1402071249420.4212@chino.kir.corp.google.com>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com> <2f62d7bb34ad1797b2990524239d4de90f8073a4.1391167128.git.rashika.kheria@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1629610436-1391806194=:4212"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1629610436-1391806194=:4212
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 7 Feb 2014, Rashika Kheria wrote:

> Mark functions as static in migrate.c because they are not used outside
> this file.
> 
> This eliminates the following warnings in mm/migrate.c:
> mm/migrate.c:1595:6: warning: no previous prototype for ‘numamigrate_update_ratelimit’ [-Wmissing-prototypes]
> mm/migrate.c:1619:5: warning: no previous prototype for ‘numamigrate_isolate_page’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: David Rientjes <rientjes@google.com>
--531381512-1629610436-1391806194=:4212--

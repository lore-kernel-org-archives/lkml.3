Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3KZBbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:31:35 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:53161 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab3KZBbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:31:32 -0500
Date: Mon, 25 Nov 2013 17:31:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>
cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Greg Thelen <gthelen@google.com>, Glauber Costa <glommer@gmail.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
In-Reply-To: <20131122001859.GA9510@logfs.org>
Message-ID: <alpine.DEB.2.02.1311251730160.27270@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131122001859.GA9510@logfs.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-602059341-1385429491=:27270"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-602059341-1385429491=:27270
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 21 Nov 2013, Jörn Engel wrote:

> One ancient option I sometime miss was this:
> 	- Kill the biggest process.
> 

That's what both the system and memcg oom killer currently do unless you 
change how "biggest process" is defined with /proc/pid/oom_score_adj.  The 
goal is the kill a single process with the highest rss to avoid having to 
kill many different processes.
--531381512-602059341-1385429491=:27270--

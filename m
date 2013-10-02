Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3JBAq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 20:46:28 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:32784 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3JBAqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 20:46:25 -0400
Message-ID: <524B6D05.5030609@gmail.com>
Date: Tue, 01 Oct 2013 20:47:01 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com
Subject: Re: [patch for-3.12] mm, memcg: protect mem_cgroup_read_events for
 cpu hotplug
References: <alpine.DEB.2.02.1310011629350.27758@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1310011629350.27758@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(10/1/13 7:31 PM), David Rientjes wrote:
> for_each_online_cpu() needs the protection of {get,put}_online_cpus() so
> cpu_online_mask doesn't change during the iteration.
>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


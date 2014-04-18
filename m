Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaDRUsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 16:48:51 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:42920 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbaDRUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 16:48:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21329.36761.970643.523119@quad.stoffel.home>
Date: Fri, 18 Apr 2014 16:48:25 -0400
From: "John Stoffel" <john@stoffel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Robert Haas <robertmhaas@gmail.com>,
        Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>,
        Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 0/2] Disable zone_reclaim_mode by default v2
In-Reply-To: <20140418130543.8619064c0e5d26cd914c4c3c@linux-foundation.org>
References: <1396945380-18592-1-git-send-email-mgorman@suse.de>
	<20140418130543.8619064c0e5d26cd914c4c3c@linux-foundation.org>
X-Mailer: VM 8.2.0b under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andrew" == Andrew Morton <akpm@linux-foundation.org> writes:

Andrew> On Tue,  8 Apr 2014 09:22:58 +0100 Mel Gorman <mgorman@suse.de> wrote:
>> Changelog since v1
>> o topology comment updates
>> 
>> When it was introduced, zone_reclaim_mode made sense as NUMA distances
>> punished and workloads were generally partitioned to fit into a NUMA
>> node. NUMA machines are now common but few of the workloads are NUMA-aware
>> and it's routine to see major performance due to zone_reclaim_mode being
>> enabled but relatively few can identify the problem.


This is unclear here.  "see major performance <what> due" doesn't make
sense to me.  


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3LQPN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:13:26 -0500
Received: from bitsync.net ([80.83.126.10]:38987 "EHLO bitsync.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab3LQPNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:13:25 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2013 10:13:25 EST
Message-ID: <52B068B7.4070304@bitsync.net>
Date: Tue, 17 Dec 2013 16:07:35 +0100
From: Zlatko Calusic <zcalusic@bitsync.net>
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/7] Configurable fair allocation zone policy v2r6
References: <1386943807-29601-1-git-send-email-mgorman@suse.de>
In-Reply-To: <1386943807-29601-1-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.12.2013 15:10, Mel Gorman wrote:
> Kicked this another bit today. It's still a bit half-baked but it restores
> the historical performance and leaves the door open at the end for playing
> nice with distributing file pages between nodes. Finishing this series
> depends on whether we are going to make the remote node behaviour of the
> fair zone allocation policy configurable or redefine MPOL_LOCAL. I'm in
> favour of the configurable option because the default can be redefined and
> tested while giving users a "compat" mode if we discover the new default
> behaviour sucks for some workload.
>

I'll start a 5-day test of this patchset in a few hours, unless you can 
send an updated one in the meantime. I intend to test it on a rather 
boring 4GB x86_64 machine that before Johannes' work had lots of trouble 
balancing zones. Would you recommend to use the default settings, i.e. 
don't mess with tunables at this point?

Regards,
-- 
Zlatko


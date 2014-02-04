Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaBDHR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 02:17:29 -0500
Received: from ofcsgdbm.dwd.de ([141.38.3.245]:53929 "EHLO ofcsgdbm.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbaBDHRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 02:17:19 -0500
Date: Tue, 4 Feb 2014 07:17:18 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: David Rientjes <rientjes@google.com>
cc: Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org
Subject: Re: Need help in bug in isolate_migratepages_range
In-Reply-To: <alpine.DEB.2.02.1402031602060.10778@chino.kir.corp.google.com>
Message-ID: <alpine.LRH.2.02.1402040713220.13901@diagnostix.dwd.de>
References: <alpine.LRH.2.02.1401312037340.6630@diagnostix.dwd.de> <20140203122052.GC2495@dhcp22.suse.cz> <alpine.LRH.2.02.1402031426510.13382@diagnostix.dwd.de> <20140203162036.GJ2495@dhcp22.suse.cz> <52EFC93D.3030106@suse.cz>
 <alpine.DEB.2.02.1402031602060.10778@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, David Rientjes wrote:

> On Mon, 3 Feb 2014, Vlastimil Babka wrote:
>
>> It seems to come from balloon_page_movable() and its test page_count(page) ==
>> 1.
>>
>
> Hmm, I think it might be because compound_head() == NULL here.  Holger,
> this looks like a race condition when allocating a compound page, did you
> only see it once or is it actually reproducible?
>
No, this only happened once. It is not reproducable, the system was running
for four days without problems. And before this kernel, five years without
any problems.

Thanks,
Holger

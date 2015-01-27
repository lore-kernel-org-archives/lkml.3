Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbbA0Igo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:36:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbbA0Igm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:36:42 -0500
Message-ID: <54C74E17.6020703@suse.cz>
Date: Tue, 27 Jan 2015 09:36:39 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/page_alloc: expands broken freepage to proper
 buddy list when steal
References: <1418022980-4584-1-git-send-email-iamjoonsoo.kim@lge.com> <1418022980-4584-3-git-send-email-iamjoonsoo.kim@lge.com> <54856F88.8090300@suse.cz> <20141210063840.GC13371@js1304-P5Q-DELUXE> <54C73FB5.30000@suse.cz> <20150127083419.GF11358@js1304-P5Q-DELUXE>
In-Reply-To: <20150127083419.GF11358@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2015 09:34 AM, Joonsoo Kim wrote:
> On Tue, Jan 27, 2015 at 08:35:17AM +0100, Vlastimil Babka wrote:
>> On 12/10/2014 07:38 AM, Joonsoo Kim wrote:
>> > After your patch is merged, I will resubmit these on top of it.
>> 
>> Hi Joonsoo,
>> 
>> my page stealing patches are now in -mm so are you planning to resubmit this? At
>> least patch 1 is an obvious bugfix, and patch 4 a clear compaction overhead
>> reduction. Those don't need to wait for the rest of the series. If you are busy
>> with other stuff, I can also resend those two myself if you want.
> 
> Hello,
> 
> I've noticed that your patches are merged. :)
> If you are in hurry, you can resend them. I'm glad if you handle it.
> If not, I will resend them, maybe, on end of this week.

Hi,

end of week is fine! I'm in no hurry, just wanted to know the status.

> In fact, I'm testing your stealing patches on my add-hoc fragmentation
> benchmark. It would be finished soon and, after that, I can resend this
> patchset.

Good to hear! Thanks.

> Thanks.
> 


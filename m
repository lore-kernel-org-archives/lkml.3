Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbbAMJpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:45:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33988 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbbAMJpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:45:19 -0500
Message-ID: <54B4E92D.5050800@suse.cz>
Date: Tue, 13 Jan 2015 10:45:17 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org
Subject: Re: [PATCH 1/1 linux-next] mm,compaction: move suitable_migration_target()
 under CONFIG_COMPACTION
References: <1420301068-19447-1-git-send-email-fabf@skynet.be> <54AC1991.9060908@suse.cz> <1453795579.577520.1420839030684.open-xchange@webmail.nmp.proximus.be>
In-Reply-To: <1453795579.577520.1420839030684.open-xchange@webmail.nmp.proximus.be>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 10:30 PM, Fabian Frederick wrote:
> 
> 
>> On 06 January 2015 at 18:21 Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>>
>> On 01/03/2015 05:04 PM, Fabian Frederick wrote:
>> > suitable_migration_target() is only used by isolate_freepages()
>> > Define it under CONFIG_COMPACTION || CONFIG_CMA is not needed.
>> >
>> > Fix the following warning:
>> > mm/compaction.c:311:13: warning: 'suitable_migration_target' defined
>> > but not used [-Wunused-function]
>> >
>> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
>>
>> I agree, I would just move it to the section where isolation_suitable() and
>> related others are, maybe at the end of this section below
>> update_pageblock_skip()?
> 
> Yes of course, that would solve the warning as well.

So, send a v2? :)
Thanks.


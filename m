Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab3AMSOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 13:14:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:56697 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3AMSOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 13:14:41 -0500
Message-ID: <50F2F9CD.6080904@infradead.org>
Date: Sun, 13 Jan 2013 10:15:41 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Michal Nazarewicz <mina86@mina86.com>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Andy Whitcroft <apw@shadowen.org>, Alexander Nyberg <alexn@dsv.su.se>
Subject: Re: [PATCH v2 1/2] Fix wrong EOF compare
References: <1357871401-7075-1-git-send-email-minchan@kernel.org> <xa1tbocvby0s.fsf@mina86.com> <1358077473.32505.10@driftwood>
In-Reply-To: <1358077473.32505.10@driftwood>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/13 03:44, Rob Landley wrote:
> On 01/11/2013 08:21:55 AM, Michal Nazarewicz wrote:
>> On Fri, Jan 11 2013, Minchan Kim <minchan@kernel.org> wrote:
>> > The C standards allows the character type char to be singed or unsinged,
>> > depending on the platform and compiler. Most of systems uses signed char,
>> > but those based on PowerPC and ARM processors typically use unsigned char.
>> > This can lead to unexpected results when the variable is used to compare
>> > with EOF(-1). It happens my ARM system and this patch fixes it.
>> >
>> > Cc: Mel Gorman <mgorman@suse.de>
>> > Cc: Andy Whitcroft <apw@shadowen.org>
>> > Cc: Alexander Nyberg <alexn@dsv.su.se>
>> > Cc: Michal Nazarewicz <mina86@mina86.com>
>>
>> Acked-by: Michal Nazarewicz <mina86@mina86.com>
>>
>> > Cc: Randy Dunlap <rdunlap@infradead.org>
>> > Signed-off-by: Minchan Kim <minchan@kernel.org>
>> > ---
>> >  Documentation/page_owner.c |    7 ++++---
>> >  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> My kernel tree doesn't have Documentation/page_owner.c, where do I find this file?

It's in -mm (mmotm), so Andrew can/should merge this ...


-- 
~Randy

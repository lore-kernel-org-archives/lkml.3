Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab3EOUqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:46:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab3EOUqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:46:24 -0400
Message-ID: <5193F3CC.8020205@redhat.com>
Date: Wed, 15 May 2013 16:45:00 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv11 3/4] zswap: add to mm/
References: <1368448803-2089-1-git-send-email-sjenning@linux.vnet.ibm.com> <1368448803-2089-4-git-send-email-sjenning@linux.vnet.ibm.com> <15c5b1da-132a-4c9e-9f24-bc272d3865d5@default> <20130514163541.GC4024@medulla> <f0272a06-141a-4d33-9976-ee99467f3aa2@default> <20130514225501.GA11956@cerebellum> <4d74f5db-11c1-4f58-97f4-8d96bbe601ac@default> <20130515185506.GA23342@phenom.dumpdata.com> <57917f43-ab37-4e82-b659-522e427fda7f@default>
In-Reply-To: <57917f43-ab37-4e82-b659-522e427fda7f@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 03:35 PM, Dan Magenheimer wrote:
>> From: Konrad Rzeszutek Wilk
>> Subject: Re: [PATCHv11 3/4] zswap: add to mm/
>>
>>> Sorry, but I don't think that's appropriate for a patch in the MM subsystem.
>>
>> I am heading to the airport shortly so this email is a bit hastily typed.
>>
>> Perhaps a compromise can be reached where this code is merged as a driver
>> not a core mm component. There is a high bar to be in the MM - it has to
>> work with many many different configurations.
>>
>> And drivers don't have such a high bar. They just need to work on a specific
>> issue and that is it. If zswap ended up in say, drivers/mm that would make
>> it more palpable I think.
>>
>> Thoughts?
>
> Hmmm...
>
> To me, that sounds like a really good compromise.

Come on, we all know that is nonsense.

Sure, the zswap and zbud code may not be in their final state yet,
but they belong in the mm/ directory, together with the cleancache
code and all the other related bits of code.

Lets put them in their final destination, and hope the code attracts
attention by as many MM developers as can spare the time to help
improve it.

-- 
All rights reversed

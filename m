Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3EPRKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:10:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab3EPRKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:10:19 -0400
Message-ID: <51951211.5080804@redhat.com>
Date: Thu, 16 May 2013 13:06:25 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
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
        devel@driverdev.osuosl.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCHv11 3/4] zswap: add to mm/
References: <1368448803-2089-1-git-send-email-sjenning@linux.vnet.ibm.com> <1368448803-2089-4-git-send-email-sjenning@linux.vnet.ibm.com> <15c5b1da-132a-4c9e-9f24-bc272d3865d5@default> <20130514163541.GC4024@medulla> <f0272a06-141a-4d33-9976-ee99467f3aa2@default> <519408D6.10903@redhat.com> <b12c2e22-f41c-490d-9d74-c85aa397e017@default>
In-Reply-To: <b12c2e22-f41c-490d-9d74-c85aa397e017@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 12:45 PM, Dan Magenheimer wrote:
>> From: Rik van Riel [mailto:riel@redhat.com]

>> I'm not sure we can get it right before people actually start
>> using it for real world setups, instead of just running benchmarks
>> on it.
>>
>> The sooner we get the code out there, where users can play with
>> it (even if it is disabled by default and needs a sysfs or
>> sysctl config option to enable it), the sooner we will know how
>> well it works, and what needs to be changed.
>
> /me sets stage of first Star Wars (1977)
>
> /me envisions self as Obi-Wan Kenobi, old and tired of fighting,
> in lightsaber battle with protege Darth Vader / Anakin Skywalker
>
> /me sadly turns off lightsaber, holds useless handle at waist,
> takes a deep breath, and promptly gets sliced into oblivion.
>
> Time for A New Hope(tm).

I would have hoped that in the battle against memory
shortages, we would all be on the same side.

-- 
All rights reversed

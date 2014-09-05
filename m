Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaIESqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:46:00 -0400
Received: from mail-ph.de-nserver.de ([85.158.179.214]:54092 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaIESp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:45:58 -0400
X-Fcrdns: No
Message-ID: <540A04E9.6020606@profihost.ag>
Date: Fri, 05 Sep 2014 20:46:01 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
CC: Arne Wiebalck <Arne.Wiebalck@cern.ch>, Peter Kieser <peter@kieser.ca>,
        "eddie@ehuk.net" <eddie@ehuk.net>,
        Francis Moreau <francis.moro@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] bcache changes for 3.17
References: <20140805043346.GF541@moria.home.lan> <53E10D48.1010700@kernel.dk> <53E7251B.3080305@kieser.ca> <540966BA.9030106@gmail.com> <5409C5FC.6020406@kernel.dk> <5409D8BC.7030003@ehuk.net> <5409E7AB.7040704@kieser.ca> <F71A0899-EF6F-44A3-B207-E1DACC8721B6@cern.ch> <5409EE75.9060407@kernel.dk> <20140905183301.GB17903@daterainc.com>
In-Reply-To: <20140905183301.GB17903@daterainc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 185.39.223.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 05.09.2014 20:33, schrieb Kent Overstreet:
> On Fri, Sep 05, 2014 at 11:10:13AM -0600, Jens Axboe wrote:
>> On 09/05/2014 11:03 AM, Arne Wiebalck wrote:
>>>
>>> On Sep 5, 2014, at 6:41 PM, Peter Kieser <peter@kieser.ca>
>>>   wrote:
>>>
>>>>
>>>> On 2014-09-05 8:37 AM, Eddie Chapman wrote:
>>>>> On 05/09/14 15:17, Jens Axboe wrote:
>>>>>> (from oldest to newest). And that's just from 3.16 to 3.17-rc3, going
>>>>>> all the way back to 3.10 would be a lot of work. If there's anyone that
>>>>>> cares about bcache on stable kernels (and actually use it), now would be
>>>>>> a good time to pipe up.
>>>>>
>>>>> Just "piping up" as I care about bcache and actually use it in production on 3.10! Shame I don't have the knowledge to try and backport these though :-)
>>>>>
>>>>> Eddie
>>>>
>>>> I'm "piping up" as well, I use bcache on 3.10 in production.
>>>>
>>>> -Peter
>>>>
>>>
>>>
>>> More "piping up": we currently use bcache on a few nodes in production, on 3.14 and 3.15, and plan to roll it out on a wider scale now.
>>> If necessary we'll go with these kernels, but we'd certainly prefer our usual 3.10-based CentOS kernel.
>>
>> OK, so we definitely have people using it in production. My concern was
>> that whomever does the backport of the appropriate patches to 3.10/14/15
>> stable would have an audience for getting some amount of testing of such
>> a patch series.
>>
>> Now we just need someone to line up to do the work...
>
> I can try and make some time for backporting; if we've got people lined up for
> testing that will help a lot.
>
> Backporting fixes to 3.10 will be harder, but if memory serves there hasn't been
> as much churn since 3.14 so backporting fixes to then shouldn't be too bad. If
> Stefan wants to post what he's got for 3.10 though I can try and backport some
> more fixes on top of that, though

You'll find them here:
https://github.com/profihost/linux-stable/commits/bcache_latest_fixes

Most probably you don't want the last four.

Stefan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab3HBHoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 03:44:37 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:58464 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863Ab3HBHof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:44:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAOSRKdRTrORuV0zibXZT=P-aL98QOkouZ=PreFs7wWSjjaAFLA@mail.gmail.com>
References: <CAOSRKdTOcYOZ4fD5gXe_57dA028rGmR30T32FQ6MeruAq2p04g@mail.gmail.com>
	<20130801143650.GB22250@order.stressinduktion.org>
	<CAOSRKdRTrORuV0zibXZT=P-aL98QOkouZ=PreFs7wWSjjaAFLA@mail.gmail.com>
Date: Fri, 2 Aug 2013 09:44:33 +0200
Message-ID: <CAOSRKdROnu=Nr=j4OqBWcoibjHtxWWCxgudM-cucEeu0wnOoTg@mail.gmail.com>
Subject: Re: PROBLEM: 3.11.0-rc2+ lost of connectivity
From: Sebastiano Spicuglia <spicuglia.sebastiano@gmail.com>
To: Sebastiano Spicuglia <spicuglia.sebastiano@gmail.com>,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, donald.c.skidmore@intel.com,
        gregory.v.rose@intel.com, peter.p.waskiewicz.jr@intel.com,
        alexander.h.duyck@intel.com, john.ronciak@intel.com,
        tushar.n.dave@intel.com, davem@davemloft.net, netdev@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, Patrick McHardy <kaber@trash.net>,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I let the system running for almost 12 hours
but the failure didn't show up.

I'll provide you the dropwatch output once the
failure happens again.

- Sebastiano


On Thu, Aug 1, 2013 at 4:40 PM, Sebastiano Spicuglia
<spicuglia.sebastiano@gmail.com> wrote:
> Hi Hannes,
>
> here the info about the commit:
>
> commit 6c504ecf506705a6575541b28824e13090bd223b
> Merge: 2408c2e bf903e4
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Fri Jul 26 14:40:10 2013 -0700
>
> Regards
> Sebastiano
>
>
> On Thu, Aug 1, 2013 at 4:36 PM, Hannes Frederic Sowa
> <hannes@stressinduktion.org> wrote:
>> On Thu, Aug 01, 2013 at 04:34:00PM +0200, Sebastiano Spicuglia wrote:
>>> [Kernel version from /proc/version ]
>>>
>>> Linux version 3.11.0-rc2+ (root@cache.pdbg) (gcc version 4.7.2 (Debian
>>> 4.7.2-5) ) #5 SMP Thu Aug 1 14:20:35 CEST 2013
>>
>> Which commit exactly?
>>
>> Thanks,
>>
>>   Hannes
>>

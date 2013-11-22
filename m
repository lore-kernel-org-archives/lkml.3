Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab3KVQSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:18:48 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:39485 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab3KVQSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:18:47 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <F6786E45-566F-47C5-974A-B2C1B9B674E4@m3y3r.de>
References: <1384980928.3312.6.camel@localhost.localdomain>
	<alpine.DEB.2.00.1311221036020.16356@skynet.skynet.ie>
	<CAKMK7uGoAN=PHu+=1FmXPGyZxg3+Mm2awJgkOfO8zBDF2-5arQ@mail.gmail.com>
	<F6786E45-566F-47C5-974A-B2C1B9B674E4@m3y3r.de>
Date: Fri, 22 Nov 2013 17:18:46 +0100
X-Google-Sender-Auth: RpqCDwISjdvfdmGFEGh9GcIAv6k
Message-ID: <CAKMK7uEHo3N-R5W6m_-gyEkuq0WPN=YUzJUpdG=MeznPcY2Haw@mail.gmail.com>
Subject: Re: [i915] BUG: Bad page state in process Xorg
From: Daniel Vetter <daniel@ffwll.ch>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 4:54 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
>> Am 22.11.2013 um 11:55 schrieb Daniel Vetter <daniel@ffwll.ch>:
>>
>> On Fri, Nov 22, 2013 at 11:36 AM, Dave Airlie <airlied@linux.ie> wrote:
>>>> Hi,
>>>
>>> cc'ing mailing list,
>>>
>>> Daniel any ideas?
>>
>> Nope, not really :( And no ideas how to triage this further - if it
>> takes 9 days to hit it eventually we'll have a real hard time. Or does
>> this happen even after just a short X run?
>
> Seems to happen every time while stopping the x server. Also after a short run time.
>
> The current fedora 3.11 kernel doesn't show this bug. I'm using fedora 19, with a self compiled kernel.
>
> I did turn on config-debug-pagealloc but this didn't show any wrongness.

In that case I think the bisect is the fastest way to insight - atm
I'm really at loss what could be wrong here.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

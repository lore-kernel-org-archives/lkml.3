Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3KPO67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 09:58:59 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:44259 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab3KPO6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 09:58:52 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CADDKRnBj0SxZ_KfCYMNuuj0VCTfyiXyMaWsj09j2vHZyfGyL0w@mail.gmail.com>
References: <CADDKRnBf6OK3bOS0SBKMTgwxe-NpE2K9K6Z5sdEDjhr4Z43eBQ@mail.gmail.com>
	<CAKMK7uHiX1551kVoD1MHZN2Rz+Dm1xa7yoHu1TuABiMObFpZLw@mail.gmail.com>
	<CADDKRnBj0SxZ_KfCYMNuuj0VCTfyiXyMaWsj09j2vHZyfGyL0w@mail.gmail.com>
Date: Sat, 16 Nov 2013 15:58:51 +0100
Message-ID: <CAKMK7uHgNXtxLYqpiznv4+-XkgM4=uL_H-5HE8XYrMJsWODiGA@mail.gmail.com>
Subject: Re: [V13-prerc]: REGRESSION: "*ERROR* Timed out waiting for forcewake
 old ack to clear"
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@gmail.com>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Ben Widawsky <benjamin.widawsky@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 3:39 PM, Jörg Otte <jrg.otte@gmail.com> wrote:
> 2013/11/16 Daniel Vetter <daniel.vetter@ffwll.ch>:
>> On Sat, Nov 16, 2013 at 12:28 PM, Jörg Otte <jrg.otte@gmail.com> wrote:
>>> On startup I get the following error display on the console:
>>> "*ERROR* Timed out waiting for forcewake old ack to clear"
>>>
>>> I already reported this error a year ago at the time of v3.7
>>> ( see https://lkml.org/lkml/2012/11/27/355)
>>> which was fixed later on.
>>>
>>> Now this error is back again.  Kernel 3.12.0-09888-gf63c48
>>
>> Please boot with drm.debug=0xe, reproduce the issue and then attach
>> the complete dmesg (including all the boot message, so if it takes a
>> while to reproduce please grab an boot dmesg, too).
>>
>> Also adding the right mailing lists, see MAINTAINERS.
>>
>> Thanks, Daniel
>> --
>> Daniel Vetter
>> Software Engineer, Intel Corporation
>> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
>
> Thanks, Jörg

Yeah, we've broken the early uncore sanitize stuff again :( I'll send
out a patch asap.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

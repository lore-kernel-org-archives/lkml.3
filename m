Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab3APCzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 21:55:14 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:52318 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3APCzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 21:55:12 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1301151704100.7734@pobox.suse.cz>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
	<alpine.LNX.2.00.1301031050060.27348@pobox.suse.cz>
	<CAN+gG=GxiM-K6mSmQk4GVRbkkc5VwCW1wUeo1BEuXoZ+T-ir_A@mail.gmail.com>
	<20130106200355.GA557@polaris.bitmath.org>
	<alpine.LNX.2.00.1301151704100.7734@pobox.suse.cz>
Date: Wed, 16 Jan 2013 03:55:10 +0100
Message-ID: <CAN+gG=GhqNwiFn71NxF0ueckkh=hbKjkhix+EcaH_263Nd=sPg@mail.gmail.com>
Subject: Re: [PATCH 00/11] Support of dual pen/multitouch and new default for
 win 7 certified devices
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 5:04 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sun, 6 Jan 2013, Henrik Rydberg wrote:
>
>> > Henrik, you told us that you have a patch set fixing these
>> > dependencies on all the hid drivers, will you prepare it for 3.9? Do
>> > you want me to continue your work?
>>
>> Yes, no, yes. :-)
>>
>> That is, it would be great if you want to pick up those patches. I
>> will send you a pm shortly.
>
> So, what is the status of this code now, please?

Hi Jiri,

well here are my plans:
1. polishing the support of Nexio 42" + new default class (95% done)
2. add support for pen (it may requires more reviews) (60% done)
3. cleanup Henrik's patches and send them. (1% done - I just went
through them). Honestly, I don't know if I will be able to make it for
3.9 for this series. For the time being, it only bothers me in my
regressions tests, so depending on the work done, we may postpone it
for later.

Last thing, this week, I'm in Boston. The good is that I should be
able to test tomorrow Mika's patch about i2c-hid at Intel's lab
directly, but I won't have much time to work on hid-multitouch before
next Wednesday (the 23rd).

Cheers,
Benjamin

>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs

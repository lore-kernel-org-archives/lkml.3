Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaCGPBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:01:42 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:65222 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaCGPBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:01:40 -0500
MIME-Version: 1.0
In-Reply-To: <5318C7B9.8040408@hurleysoftware.com>
References: <CA+MoWDrTNtAHKsiBHz=W4=eJRO=m9EK_HZ7zLxb=4fg5riUQeg@mail.gmail.com>
	<CAErSpo4wdYDgTUTBDLimbviLh54C9ELXKfQ2y5qeUR1FKN8fpw@mail.gmail.com>
	<5318C7B9.8040408@hurleysoftware.com>
Date: Fri, 7 Mar 2014 16:01:39 +0100
Message-ID: <CA+MoWDpN7qK6m8fdhjjO7J6zNPm+NQSkZipQn5vmHSELXu3D_w@mail.gmail.com>
Subject: Re: My Kernel bug is celebrating 2 years. Can you help me fix it?
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "kernelnewbies@kernelnewbies.org" <kernelnewbies@kernelnewbies.org>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stoney Wang <song-bo.wang@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 8:08 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On 03/06/2014 01:27 PM, Bjorn Helgaas wrote:
>>
>> [+cc Stoney, Yinghai, Suresh, Joerg, Jiang, Pavel, Rafael, linux-pm]
>>
>> Let's add some folks who know about x2apic and VT-d.  It's hard for
>> people to magically pick stuff out of the LKML firehose :)
>>
>> On Tue, Mar 4, 2014 at 2:26 PM, Peter Senna Tschudin
>> <peter.senna@gmail.com> wrote:
>>>
>>> I have reported a bug more than two years ago and it is still
>>> affecting me. The bug report gives some information:
>>>
>>> https://bugzilla.redhat.com/show_bug.cgi?id=787299
>>>
>>> I have tried basic debug instructions from:
>>> https://www.kernel.org/doc/Documentation/power/basic-pm-debugging.txt
>>>
>>> And everything works as expected when:
>>> # echo freeze > /sys/power/state
>>> # echo disk > /sys/power/state
>>>
>>> I have asked for help for fixing it:
>>> https://lkml.org/lkml/2013/11/1/186
>>>
>>> But I don't have a serial port. How can I debug this issue without a
>>> "real" serial port? Or what else can I try? How can I explore the hint
>>> about the problem only happening with VT-d enabled in BIOS? How can I
>>> explore the hint about the problem not happening if the option
>>> nox2apic is passed to the Kernel?
>>>
>>> Thank you,
>>>
>>> Peter
>>>
>>> P.S Yes, it works on Windows.
>
>
> Windows 7 doesn't use x2apic mode.
> Windows 8 does and this same problem happened with this model: see
> http://forums.toshiba.com/t5/Windows-8-8-1/Resume-from-standby-issue-on-R830-PT321A-01K002/td-p/330110
Thank you for the information. The model is similar to mine, probably
the same motherboard. My tests were with Windows 7.

>
> Seems like your model was recently added to Toshiba's Windows 8
> compatibility list: http://support.toshiba-tie.co.jp/windows8/list_au.htm
>
> Check for a more recent BIOS update that may fix this problem.
I do that weekly since February last year, and there are no updates
available. The bad news is that the model was discontinued, so it is
possible that there will be no more BIOS updates. I'll write to
Toshiba Europe GmbH asking for a fix, by my hopes in getting an answer
are low.

>
> Regards,
> Peter Hurley
>
> PS - kernel bugs are better filed on the kernel bugzilla
> https://bugzilla.kernel.org/
Thank you!


-- 
Peter

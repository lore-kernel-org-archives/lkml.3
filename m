Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab3GYPwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:52:05 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:56050 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3GYPwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:52:01 -0400
MIME-Version: 1.0
In-Reply-To: <CADDKRnAwipzeYsrx7vyTYToPvQkhCg1PgxzCWqvbW_w+Qd9Oeg@mail.gmail.com>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	<CA+55aFyrMRDD8qe9DYXixaSLJXEURMYYku1azABA72m71_X+cA@mail.gmail.com>
	<9012759.Alzqtdvh5b@vostro.rjw.lan>
	<2218913.HKGjJcYT1G@vostro.rjw.lan>
	<CADDKRnAwipzeYsrx7vyTYToPvQkhCg1PgxzCWqvbW_w+Qd9Oeg@mail.gmail.com>
Date: Thu, 25 Jul 2013 17:52:00 +0200
Message-ID: <CADDKRnBJ8Whe5AEux=Zu9jsNHU0mRtgwgfC59ZMNXi_pRfhk9g@mail.gmail.com>
Subject: Re: Linux 3.11-rc2 (acpi backlight, revert)
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Aaron Lu <aaron.lu@intel.com>, Kalle Valo <kvalo@adurom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/25 Jörg Otte <jrg.otte@gmail.com>:
> 2013/7/25 Rafael J. Wysocki <rjw@sisk.pl>:
>> On Monday, July 22, 2013 09:54:21 PM Rafael J. Wysocki wrote:
>>> On Monday, July 22, 2013 11:11:54 AM Linus Torvalds wrote:
>>> > On Mon, Jul 22, 2013 at 6:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> > >
>>> > > Linus, do you want me to send a pull request reverting 8c5bd7a and efaa14c?
>>> >
>>> > Yes, but let's wait a while. Not because I think we'll fix the problem
>>> > (hey, miracles might happen), but because I think it would be useful
>>> > to couple the reverts with information about the particular machines
>>> > that broke (and the people who reported it). So that when we
>>> > inevitably try again, we can perhaps get some testing effort with
>>> > those machines/people.
>>> >
>>> > It doesn't seem to be a show-stopped for a large number of people, so
>>> > there's no huge hurry. I'd suggest doing the revert just in time for
>>> > rc3, but waiting until then to gather info about people who see
>>> > breakage.
>>> >
>>> > Sound like a plan?
>>>
>>> Yes, it does.
>>
>> OK, time to revert I guess.
>>
>> James, Kamal, Steven, Jörg, Martin, Kalle, please check if the apppended patch
>> fixes the backlight for you.
>>
>
> Problems, problems :-) I tried to apply on top of 3.11-rc2:
>

Ok, with the help of Kamal I got my source tree back to a consistent
state. The patch now applies successfully.

Rafael, I now can confirm the patch fixes the problems for me.

Thanks, Jörg

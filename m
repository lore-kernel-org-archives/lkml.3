Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaGKN2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:28:48 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:54490 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaGKN2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <1405027816.2613.17.camel@fedora-lan>
References: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
	<1405027816.2613.17.camel@fedora-lan>
Date: Fri, 11 Jul 2014 09:28:44 -0400
Message-ID: <CAN+gG=HVhcdP3WJ-sX_jXuMVpQJH2+f80NDGuUEStnATf2h_Nw@mail.gmail.com>
Subject: Re: [Linuxwacom-devel] [PATCH 00/15] Input - Wacom: switch from an
 USB to a HID driver
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>,
        linuxwacom-devel <linuxwacom-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Przemo,

On Thu, Jul 10, 2014 at 5:30 PM, Przemo Firszt <przemo@firszt.eu> wrote:
> Hi Benjamin,
> I'm having some problems to cleanly apply your patches - can you double
> check that they are OK?

These patches relies on a previous patchset I sent earlier. So they do
not apply cleanly on top of Dmitry's tree as long as the previous
patch set has not been merged :(

As I mentioned in the last series I sent, I pushed a git tree with the
various series applied:
https://github.com/bentiss/linux/commits/hid-wacom-legacy-3.16-rc4

First series is the split of the pad input + various cleanups:
719eaed64c...003c44a74840

Then this series:
71d0261b7b...9be3b169b23

And the last series I sent yesterday:
4fabeed121...f01c5684e6

This is not an ideal solution, but I hope we will figure out soon
enough the way we can merge this upstream (through the HID tree or the
Input tree).

Anyway, I am planing of re-sending the whole various patch series soon
so the maintainer can pick them directly instead of having to dig in
the linux-input archives.

Cheers,
Benjamin

> --
> Regards,
> Przemo
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

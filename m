Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaHPVKH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 17:10:07 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38641 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaHPVKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 17:10:05 -0400
MIME-Version: 1.0
X-Originating-IP: [72.182.51.248]
In-Reply-To: <20140815125955.243e8a5d.stealth@tiberian.ru>
References: <E1XHxA6-0000ar-2a@feisty.vs19.net>
	<20140815125955.243e8a5d.stealth@tiberian.ru>
Date: Sat, 16 Aug 2014 16:10:04 -0500
Message-ID: <CAOS_Y6RaY22vAE4JbN+WWd_O2YniyrYynWA1K_TpJqc0_phwvg@mail.gmail.com>
Subject: Re: OT: Open letter to the Linux World
From: Rob Landley <rob@landley.net>
To: Vlad Glagolev <stealth@tiberian.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 3:59 AM, Vlad Glagolev <stealth@tiberian.ru> wrote:
> Now what do we see? Complete degradation of Linux-like ecosystem. I'm

Nah, lots of embedded guys value simplicity and a modular design where
you can swap actually out parts. Check out the musl-libc.org mailing
list for example. Those mailing lists are the place for this sort of
thing, this isn't.

Way back when I wrote mdev instead of accepting udev, and I plan to do
some kind of "lunchd" in toybox (loosely based on launchd but not
crazy stuff like xml config files) as part of my project to make
android self-hosting, which I gave a talk about last year:

video: http://youtu.be/SGmtP5Lg_t0
outline: http://landley.net/talks/celf-2013.txt

Keep in mind that mainframes and minicomputers got kicked up into the
server space by the PC, and now smartphones are kicking the PC up
there. The fight between Amazon's PC cloud and IBM big iron servers is
exactly the same fight IBM's mainframes and DEC's minicomputers fought
25 years ago. Last time DEC lost, this time IBM is losing, but it
doesn't matter to the rest of us.

Plug your phone into a USB hub, add a USB keyboard, USB mouse, and USB
to VGA (or with USB3 a USB to HDMI) adapter, and you've got the
hardware of a development workstation. The software side we're working
on, but it won't be the current pile of PC userspace for the same
reason the PC didn't run MVS or VMS. Technological disruption goes
_upmarket_, not down.

Android has a no GPL in userspace policy, so nothing systemd does has
any impact on the _billion_ seat android market. Among other things,
if a company adds GPL software to Android they violate the Android
trademark licensing guidelines and can't call the result "android".
But toybox is public domain, musl is BSD licensed, they can add _our_
stuff no problem.

Fighting over the desktop market in 2014 is like Unix fighting over
the minicomputer and RISC workstation market in 1994. It doesn't
_matter_. Sure the modern equivalent of cobol programmers will make
plenty of money servicing entrenched fortune 500 fossils in that
space, but the rest of us can ignore it and focus on what will replace
it instead.

And that's highly unlikely to include a GPL'd systemd. Busybox
predates android and they're _still_ not using it. Good luck waiting
them out...

Rob

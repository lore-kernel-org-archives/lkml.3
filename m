Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaBPV51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 16:57:27 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:55980 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaBPV50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 16:57:26 -0500
MIME-Version: 1.0
Date: Sun, 16 Feb 2014 13:57:25 -0800
X-Google-Sender-Auth: AdPnOvNZXRkoMZg56M4D7lQvsDg
Message-ID: <CA+55aFyvQ4ko4J2oLbyVEZjb9=TvjcCF_PV-jGDZTR8_D+zseQ@mail.gmail.com>
Subject: Linux 3.14-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I made the rc2 announcement, I mentioned how nice and small it
was. I also mentioned that I mistrusted you guys, and that I suspected
that some people were giggling to themselves and holding back their
pull requests, evil little creatures like you are.

And I hate being right. rc2 was quite small, but rc3 makes up for it.
I quietly took all the pull requests because clearly this wasn't a
surprise, but I'm warning you - I'm going to start cursing at people
if it looks like this trend is going to continue. You've been warned.

Anyway, because the shortlog is pretty hefty, I'm doing my overview
"mergelog" here, and will post the shortlog separately as a reply to
this email for people who want more detail. The bulk is the networking
and random drivers (net, staging, usb, block, infiniband..) but
there's some arch updates too (powerpc, arm, x86) and some
documentation updates.

          Linus

(And as always for my mergelog - the people credited are the people
who send me the pull request, which is generally different from the
author of the code. See the shortlog for actual code authorship)

---

Andrew Morton (1):
  misc fixes

Ben Herrenschmidt (1):
  powerpc updates

Borislav Petkov (1):
  EDAC fixes

Bruce Fields (1):
  two nfsd bugfixes

Chris Mason (1):
  btrfs fixes

Dave Airlie (1):
  drm fixes

David Miller (1):
  networking updates

Dmitry Eremin-Solenikov (1):
  battery fixes

Greg KH (5):
  char/misc fixes
  driver core fix
  staging driver fixes
  tty/serial driver fixes
  USB fixes

Guenter Roeck (1):
  hwmon fix

Jens Axboe (1):
  block IO fixes

Kevin Hilman (1):
  ARM SoC fixes

Konrad Rzeszutek Wilk (1):
  Xen bugfixes

Linus Walleij (1):
  GPIO fixes

Mark Brown (2):
  spi fixes
  regulator fixes

Martin Schwidefsky (1):
  s390 bugfixes

Michal Simek (1):
  microblaze fixes

Neil Brown (1):
  md fixes

Nicholas Bellinger (1):
  SCSI target fixes

Paolo Bonzini (1):
  KVM fixes

Peter Anvin (2):
  x86 fixes
  x86 EFI fixes

Rafael Wysocki (1):
  ACPI and power management fixes

Rob Herring (2):
  DeviceTree fixes
  devicetree fixes

Roland Dreier (1):
  RDMA/InfiniBand fixes

Steve French (1):
  CIFS fixes

Steven Rostedt (1):
  twi tracing fixes

Takashi Iwai (1):
  sound fixes

Thomas Gleixner (2):
  timer fixes
  irq update

Tomi Valkeinen (1):
  fbdev fixes

Wolfram Sang (1):
  i2c fixes

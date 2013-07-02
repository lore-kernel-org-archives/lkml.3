Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab3GBEzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 00:55:05 -0400
Received: from mailhost-t4-p3.netultra.net ([195.5.209.79]:60538 "EHLO
	smtp-delay1.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751120Ab3GBEzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 00:55:04 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2013 00:55:03 EDT
From: Damien Wyart <damien.wyart@gmail.com>
To: Marc Haber <mh+linux-kernel@zugschlus.de>
Cc: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>, Takashi Iwai <tiwai@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Henningsson <david.henningsson@canonical.com>,
        Kay Sievers <kay@redhat.com>
Subject: Re: udevd cannot modprobe snd-hda-intel with 3.9.8
References: <51CDD1B0.70607@gmail.com> <201306282208.23429.s.L-H@gmx.de>
	<51CED59E.2030307@gmail.com> <20130701155016.GA23358@torres.zugschlus.de>
Date: Tue, 02 Jul 2013 06:47:31 +0200
In-Reply-To: <20130701155016.GA23358@torres.zugschlus.de> (Marc Haber's
	message of "Mon, 1 Jul 2013 17:50:16 +0200")
Message-ID: <87ppv136vw.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marc Haber <mh+linux-kernel@zugschlus.de> [130701 17:50]:
> The issue does not appear when one uses a Debian kernel, or uses the
> configuration that Debian uses for its kernels to build a vanilla
> kernel.org kernel. This has, after a gazillion of reoboots and
> experimenting with man different blacklist entries and kernel
> configuration, led me to the fact that this bug does not show if the
> kernel is compiled with CONFIG_SND_SUPPORT_OLD_API=y.

> So it was my error to dump backwards compatibility and to remove the
> old api support. I have now set CONFIG_SND_SUPPORT_OLD_API=y again and
> everything is fine.

Even with this option, I get the problem, so this is not enough...

-- 
Damien

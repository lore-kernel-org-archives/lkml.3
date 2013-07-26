Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab3GZEdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 00:33:11 -0400
Received: from s15372268.onlinehome-server.info ([87.106.227.76]:41900 "EHLO
	ferdi.naasa.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3GZEdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 00:33:09 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jul 2013 00:33:09 EDT
Message-ID: <51F1F9B2.9000302@naasa.net>
Date: Fri, 26 Jul 2013 06:23:14 +0200
From: Joerg Platte <jplatte@naasa.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        =?UTF-8?B?SsO2cmcgT3R0ZQ==?= <jrg.otte@gmail.com>,
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
Subject: Re: Linux 3.11-rc2 (acpi backlight, revert)
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com> <2218913.HKGjJcYT1G@vostro.rjw.lan> <CAAG0J98i-XaO_3sPWsnyEGDX77T=WiNf1K=YMhe5DvkwKotorw@mail.gmail.com> <9711528.yIoJy2i1iX@vostro.rjw.lan>
In-Reply-To: <9711528.yIoJy2i1iX@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.07.2013 21:47, Rafael J. Wysocki wrote:

> Other people who experienced problems with backlight in 3.11-rc2, please let me
> know whether or not the revert works for you too if you can.

Before reverting the patch /sys/class/backlight was empty and backlight 
brightness was set to max, now it again contains a link to acpi_video0 
on my Thinkpad 420s with intel video and adjusting the backlight works 
again.

Joerg

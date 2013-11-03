Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab3KCS5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 13:57:33 -0500
Received: from mail-ee0-f68.google.com ([74.125.83.68]:48271 "EHLO
	mail-ee0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3KCS5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 13:57:32 -0500
From: andreas.thalhammer@linux.com
Reply-To: andreas.thalhammer@linux.com
To: linux-kernel@vger.kernel.org
Subject: Re for el_es: A Desktop Linux idea: modulized open hardware database for the linux kernel config
Date: Sun, 3 Nov 2013 19:57:29 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.3-gentoo-6.0; KDE/4.11.2; x86_64; ; )
References: <201311031553.26488.andreas.thalhammer@linux.com> <20131103161819.GA4983@linux> <201311031743.26688.andreas.thalhammer@linux.com>
In-Reply-To: <201311031743.26688.andreas.thalhammer@linux.com>
MIME-Version: 1.0
Message-Id: <201311031957.29584.andreas.thalhammer@linux.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> <andreas.thalhammer <at> linux.com> writes:
>[cut down because of gmane's web interface quotation policy]
>
>> But hey, it was just an idea. A stupid one maybe. So thanks for answering 
>> anyway.
>> 
>
>
>Uh like any great idea, you need to show the world, how
>serious you are about it : do the first step and collect a few, 
>then share a link, wikipedia or pastebin style maybe for starters ;)
>
>In other words, "let's go and you do it", doesn't sound like 
>a good starting pitch ;)
>
>-L.

"If I could have, I would have" already done it. I wouldn’t know how.
I’m sorry if this soulds like "you do it"… the intension was to see what you 
think about it.

I was working with the hardware database from Fedora (RedHat): Smolt. But 
Smolt was shut down: https://fedoraproject.org/wiki/Smolt_retirement

When I started working with it, and with other resources of this kind, I 
always found that it was too chaotic because there are too many ways of 
describing how to get a Linux system running on a specific hardware. Take the 
ThinkWiki for example. It describes how to get some specific parts of specific 
ThinkPad series to work on Linux, but it could be the same procedure and/or 
patch used for other Laptops or PCs.

I had my hardware added to Smolt for the reason to have other benefit from the 
information on how to get it running (if I got it running) and which kernel 
version is at least required and other useful information.

During that time the idea came up that an automized configuration for a 
specific computer would be a benefit.

That is: make a defconfig, not for a very generic system but for very specific 
system parts. The example is: PC + Desktop + experimental + <My specific 
motherboard> + AMD_K10 SMP + RadeonHD_Barts + AllStableUSB + <My specific 
webcam> + …

This "profile" would go into a global configuration file for my computer. The 
"make defconfig" would then use this information to e.g. set this very 
specific CONFIG_SENSORS_F71882FG, because the system now knows which specific 
hardware it is built for. It will leave out all unnecessary stuff, unless 
otherwise included (in the profile). The provided information could even be 
used to tell GRUB (grub-mkconfig) for which kernel version which command line 
options must be used.

Putting all this on a server (like Smolt) and having it put together with 
version information (like: on kernel 3.2 it is CONFIG_SOMETHING whereas 
starting with 3.3 it is CONFIG_SOMETHINGELSE and includes 
CONFIG_SOMETHINGELSE_WITH_AN_OPTION) and combined with a Wiki – and all of 
that can be discussed and created online by users, would get a power-user-
community process started. Maybe. Hopefully.

With Smolt this wasn’t so. It was too limited in many ways.

There are verious Wiki, Blog and Wordpress pages that describe how to compile 
the linux kernel (and userland software) for a specific system. But there is no 
central site for that.

If Smolt had been a little "better", and more useful in the sense of "this is 
my hardware – someone with the same, what is your kernel .config file looking 
like?" would have helped a lot of non-power-users, that – nevertheless – like 
to compile their own kernel, and maybe add something that was missing in the 
distribution kernel…

Giving them a "make myconfig" with some little extra information (What type of 
use? "Desktop", how stable? "experimental", and what extra hardware? 
"<specific>" or "very general, like a distribution kernel") would make their 
lifes easier; also for power-users.

Power-users would in addition provide the config modules (like: what is needed 
for a specific hardware/hardware expansion) and help on a server site that 
hosts this information.

I’m sorry, but I cannot possibly do this all by myself. I was able to help in 
some Wikis and in Smolt, but I cannot setup such a system. Apparently I was 
only able to come up with the idea…


(Since I am not even able to answer you, I post as a follow-up to my previous 
post).

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaF2HH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 03:07:27 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50979 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaF2HH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 03:07:26 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: "Gideon D'souza" <gidisrael@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: How is an OS bound to the Linux kernel
Date: Sun, 29 Jun 2014 09:07:20 +0200
Message-ID: <1989531.qh1zHAaciq@merkaba>
User-Agent: KMail/4.14 pre (Linux/3.16.0-rc2-tp520; KDE/4.13.1; x86_64; git-f170e55; 2014-06-25)
In-Reply-To: <CAPNrq4xV+LiOhbMhBfHFuf68E1D7XCq87EJuTq0n88UMGdcg4g@mail.gmail.com>
References: <CAPNrq4xV+LiOhbMhBfHFuf68E1D7XCq87EJuTq0n88UMGdcg4g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 29. Juni 2014, 11:54:32 schrieb Gideon D'souza:
> hey guys,

Hi Gideon,

> I generally manage to understand the various pieces of the linux
> kernel and what their functions are.
> 
> However, one thing I don't fully understand is how is any OS, say
> fedora (which is what I use) is bound to the kernel.
> 
> Lets say I want to just build a system on top of linux that boots and
> keeps printing hello world to the screen. When the user presses a key
> it exits.
> 
> How would I begin to do this? What should I read or look at?
> 
> I'm guessing it's a two part thing right, one I need to somehow tell
> the kernel what to do after booting, and second I'll have to tell the
> kernel what the screen is ? Where would I find more information about
> this?
> 
> Note: I actually want to make the program I described so tips on how
> to play with grub to get the whole thing to work would also be
> helpful.

Look for init= kernel parameter (there is a kernel-parameter documentation file 
in kernel doc drawer).

And I suggest looking through things like Linux From Scratch. I am not sure 
how useful this is to your case.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

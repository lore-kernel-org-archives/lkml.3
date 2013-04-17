Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966834Ab3DQVvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 17:51:13 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:48045 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965345Ab3DQVvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 17:51:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130417173903.GB4140@magazyn-ziarno.chello.pl>
References: <20130417173903.GB4140@magazyn-ziarno.chello.pl>
Date: Wed, 17 Apr 2013 23:51:08 +0200
Message-ID: <CAMeQTsbXcvuHK5zqN=8Xzdjyk0GwxZ_QUR3htVk+M2oi98a9BA@mail.gmail.com>
Subject: Re: How to override GMA500 resolution set by BIOS?
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Marcin Szewczyk <Marcin.Szewczyk@wodny.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 7:39 PM, Marcin Szewczyk
<Marcin.Szewczyk@wodny.org> wrote:
> Hello,
>
> I've got a problem with GMA500 on my EVOC EC2-1711. The graphics
> adapter's resolution is set by selecting an option in BIOS but I would
> like to override it. Can kernel or Xorg do this?
>
> There are two modes "almost" right for an 800x600 16bit LVDS screen I
> have.  The first one is 800x600 but in 24bit LVDS mode, so colors are
> mangled. The second one is 800x480 16bit -- colors are right, but the
> screen cuts the image at line 480.
>
> I've tried video=, overwriting modes via patched 915resolution, vga= and
> Xorg modesetting driver. Nothing works.
>
> Does anyone know if it's possible to override the mode?

Hi Marcin, I haven't played much with 16 bpp on the gma500 kernel driver but at
the moment it seems broken. I added a screen section to xorg.conf with
DefaultDepth 16 running the fbdev driver. That, at least tries to do the right
thing but gma500 fails in setting it up. On the other hand, you managed to set
800x480 at 16bbp. Have you tried the vesafb driver? Might do a better job.

-Patrik Jakobsson

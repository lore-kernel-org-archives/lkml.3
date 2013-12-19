Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab3LSKqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:46:53 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51453 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab3LSKqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:46:51 -0500
MIME-Version: 1.0
In-Reply-To: <20131219000346.0f722b65@alan.etchedpixels.co.uk>
References: <s5hlhzik3kk.wl%tiwai@suse.de>
	<CANq1E4TFKDduy71jCXy+8CMS1_OFxWEpsHY3AA0RUJPW4VE8hg@mail.gmail.com>
	<20131218092941.GA19210@gmail.com>
	<20131219000346.0f722b65@alan.etchedpixels.co.uk>
Date: Thu, 19 Dec 2013 11:46:51 +0100
Message-ID: <CANq1E4Q3KiLMC-ETFs+FAmTv3yWdCyqG2c+KzGFX4xZmcxLbJg@mail.gmail.com>
Subject: Re: cirrusdrmfb broken with simplefb
From: David Herrmann <dh.herrmann@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Dec 19, 2013 at 1:03 AM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
>> > That bug always existed, simplefb is just the first driver to hit it
>> > (vesafb/efifb didn't use resources). I'm aware of the issue but as a
>> > workaround you can simply disable CONFIG_X86_SYSFB. That restores
>> > the old behavior.
>>
>> This looks like a regression, so we'll either need a fix or we'll have
>> to mark CONFIG_X86_SYSFB as CONFIG_BROKEN.
>
> Kernel bugzilla has entries for simplefb breaking both vesafb and matrox
> mga.

Thanks for the hints. I've read through all I could find and tried to
provide some help.

I'm kind of confused, most of them enable CONFIG_X86_SYSFB (which is
'n' by default) but don't read the help text. I did my best to tell
people that this option requires CONFIG_FB_SIMPLE, but if you don't
read the help-text you won't notice that. Don't know what to do about
that..

Thanks
David

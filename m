Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3KPUJl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 15:09:41 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61654 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3KPUJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 15:09:32 -0500
MIME-Version: 1.0
In-Reply-To: <1363869397.17680.24.camel@pasglop>
References: <1363791074-16415-1-git-send-email-grant.likely@secretlab.ca>
	<1363791074-16415-3-git-send-email-grant.likely@secretlab.ca>
	<1363791479.12701.9.camel@pasglop>
	<CACxGe6u2wNbPQSOPRCRO0To5UC-b8rXYanv2xv26hk5oaozvPA@mail.gmail.com>
	<1363839594.17680.19.camel@pasglop>
	<CACxGe6sXcg51VhFujsjCsMzF80pdy_QhAposdmya4-C0eEcuUw@mail.gmail.com>
	<1363851836.17680.20.camel@pasglop>
	<CACxGe6thdnQo6sPDccEGzUEkXFDGRD4aq_DJOop6Cincb94ODA@mail.gmail.com>
	<1363869397.17680.24.camel@pasglop>
Date: Sat, 16 Nov 2013 21:09:32 +0100
X-Google-Sender-Auth: wgLS2QOmdDMj5Y7wgMx4i-4LxG8
Message-ID: <CAMuHMdVji-iT4_53S5nD8eppwW7tNT1q_Y-CshRuo3_KF7FsrA@mail.gmail.com>
Subject: Re: [PATCH 2/2] of: remove /proc/device-tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 1:36 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Thu, 2013-03-21 at 08:16 +0000, Grant Likely wrote:
>> On Thu, Mar 21, 2013 at 7:43 AM, Benjamin Herrenschmidt
>> <benh@kernel.crashing.org> wrote:
>> > On Thu, 2013-03-21 at 07:35 +0000, Grant Likely wrote:
>> >> > Shouldn't we have the symlink just be a config option itself ?
>> >> > Eventually distros might want get rid of it completely ..
>> >>
>> >> Why? It is the cheapest thing in the world and it means the ABI
>> >> doesn't change at all.
>> >
>> > It's also gross and forces sysfs to remain in /sys which isn't a kernel
>> > enforced policy afaik.
>>
>> Documentation/sysfs-rules.txt, Line 30
>
> Whatever... it's still gross :-)

Even Android mounts it there ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

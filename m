Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaIVUoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:44:04 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:39901 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaIVUoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:44:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAOnawYp7kv7Zjn4j-j4-TUOshE9G1uXWEqXB_=RHePNwNLmwWA@mail.gmail.com>
References: <CAOnawYp7kv7Zjn4j-j4-TUOshE9G1uXWEqXB_=RHePNwNLmwWA@mail.gmail.com>
Date: Mon, 22 Sep 2014 13:43:59 -0700
X-Google-Sender-Auth: 8SPM5oePbeWr0H9SWAwV8DgsC_Q
Message-ID: <CA+55aFwX_nV9oUjh6u5WY=jpLxN-a5GFLmXQWDbHW0Yom9OOVA@mail.gmail.com>
Subject: Re: Stupid NVIDIA 3D vgaarb.c patch
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?UTF-8?B?QyBCZXJnc3Ryw7Zt?= <cbergstrom@pathscale.com>,
        David Airlie <airlied@linux.ie>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: DRI <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding proper people and mailing lists..

The PCI_CLASS_DISPLAY_VGA test goes back to the very beginning by
BenH, and I have no idea if adding PCI_CLASS_DISPLAY_3D is
appropriate, but hopefully somebody does. The fact that it makes
things work certainly argues fairly convincingly for it, but I want
some backup here.

Dave, BenH?

Christopher(?), can you please also specify which laptop etc. And the
patch itself seems to have come from somebody else, unless you're
Lekensteyn. So we'd want to get the provenance of that too.

                Linus

On Mon, Sep 22, 2014 at 1:28 PM, C Bergström <cbergstrom@pathscale.com> wrote:
> Hi Linus,
>
> I don't know who the original author is and I can have one of the distro
> graphics friends review it, but I need this patch below to get NVIDIA
> drivers to work (without using any Intel graphics) on my laptop
> http://pastebin.com/wpmFi38k
>
> Sorry - I know this is not the proper way to submit a patch, but it's
> trivial and I'm not a kernel dev.
>
> Thanks
>
> ./C

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaAPLWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 06:22:52 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:42763 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaAPLWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 06:22:50 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <CA+55aFzcHCg1Azf0t4KrYx0N1z0xaeT8fNHJEW5og3VBd+UPOA@mail.gmail.com>
References: <CA+55aFzcHCg1Azf0t4KrYx0N1z0xaeT8fNHJEW5og3VBd+UPOA@mail.gmail.com>
Date: Thu, 16 Jan 2014 12:22:48 +0100
Message-ID: <CAKMK7uFYJbeapYbMGS6BhDD5wP9NMqmSU_KpzqYdfgwAULMxsw@mail.gmail.com>
Subject: Re: Baytrail problems (was Re: Linux 3.13-rc8)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paul Drews <paul.drews@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dave Airlie <airlied@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 2:49 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>> - i915 console doesn't work
>
> Daniel/Dave?

We have a bugzilla from Alan Cox but haven't gained too much clue yet
what's been going wrong. Especially that old kernels managed to get it
to work by forcing the vga output is rather puzzling:

https://bugzilla.kernel.org/show_bug.cgi?id=68451

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

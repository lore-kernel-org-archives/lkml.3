Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaFABw4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 21:52:56 -0400
Received: from mail.lang.hm ([64.81.33.126]:59944 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbaFABwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 21:52:55 -0400
Date: Sat, 31 May 2014 18:52:45 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel@vger.kernel.org, robbat2@gentoo.org
Subject: Re: Licensing & copyright of kernel .config files (defconfig,
 *config)
In-Reply-To: <robbat2-20140601T012929-356267352Z@orbis-terrarum.net>
Message-ID: <alpine.DEB.2.02.1405311848450.14084@nftneq.ynat.uz>
References: <robbat2-20140601T012929-356267352Z@orbis-terrarum.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not a Lawyer

But I would start asking the same questions about these files that we ask about 
header files.

Is there anything in the file that is not functionally required? (I believe the 
answer is no, everything there is required to be what it is to make the kernel 
work)

The only possible grounds for copyright would be a claim that deciding which 
things to select and which things to not select is a "creative" work.

Given that the only value in selecting or not selecting something is to make 
things in the kernel work, I'm not sure that would pass muster. But if it did, 
that would make the copyright be owned by the person who made those selections.

David Lang


On Sun, 1 Jun 2014, Robin H. Johnson wrote:

> (Please CC me on replies, not subscribed to LKML)
>
> Hi,
>
> Somewhat of an odd question, but none of the files in question seem to
> have a copyright header on them...
>
> For a kernel .config file, either from one of the defconfig or any other
> *config option that automates the answer:
> 1. What license does the file fall under?
> 2. Who are the copyright holders?
>
> Naively, since the defconfigs are bundled with the kernel, that could
> fall under GPLv2-only implicitly, but lacking any explicit copyright
> headers makes this interesting (arch/*/configs/* contain lots of files,
> no copyright headers on them).
>
> If I manually write the names of some configuration options to a new
> .config file, at that point I logically am the only author and have
> copyright of it. My editor slaps a default license on it of BSD-2.
> Thereafter I run olddefconfig, and now it's a combined work of the
> kernel's defconfig and my manual settings. If GPL-2 was inherited from
> the kernel tree, this is now a combined BSD-GPL2 work, or is it? The
> kernel config tools did consider my file as input, possibly overrode the
> settings if they didn't work with others, and re-output everything.
>
> If the files are to be marked with a copyright header, who is the holder
> of it that it should be attributed to?
>
> Alternatively, is this a case where the work is not copyrightable, and
> the files should have a notice to that effect?
>
> Background:
> Gentoo has a bunch of "stock" kernel configurations for release
> engineering, our initramfs tool (genkernel), and other endeavors over
> the years. These projects claim BSD, GPL2, LGPL2 on various pieces, and
> I don't think they can all be correct. I'm working on getting them into
> one place, because some of them have been getting stale, but the
> differing licenses raised a red flag to me.
>
>

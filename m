Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaFBESM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 00:18:12 -0400
Received: from mail.lang.hm ([64.81.33.126]:34018 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaFBESL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 00:18:11 -0400
Date: Sun, 1 Jun 2014 21:18:05 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel@vger.kernel.org, robbat2@gentoo.org,
        Ken Moffat <zarniwhoop@ntlworld.com>
Subject: Re: Licensing & copyright of kernel .config files (defconfig,
 *config)
In-Reply-To: <robbat2-20140601T231524-149301602Z@orbis-terrarum.net>
Message-ID: <alpine.DEB.2.02.1406012114390.31783@nftneq.ynat.uz>
References: <robbat2-20140601T012929-356267352Z@orbis-terrarum.net> <20140601230146.GB31939@milliways> <robbat2-20140601T231524-149301602Z@orbis-terrarum.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not seeing where there is a problem, unless you are trying to assume that 
you have no right to distribute them at all.

there is no source for the .config file, it is the source. so when you 
distribute it, you are complying with any distribution requirements.

it could be argued that distributing the kernel requires distribution of the 
.config, but that's been violated so much that it's hard to see anyone worrying 
about it (and it's best practice to distribute it anyway, and trival to make it 
be part of the kernel via /proc)

what is it that's worrying you and causing the need to question the licenseing?

David Lang

On Sun, 1 Jun 2014, Robin H. Johnson wrote:

> On Mon, Jun 02, 2014 at 12:01:46AM +0100, Ken Moffat wrote:
>>> Naively, since the defconfigs are bundled with the kernel, that could
>>> fall under GPLv2-only implicitly, but lacking any explicit copyright
>>> headers makes this interesting (arch/*/configs/* contain lots of files,
>>> no copyright headers on them).
>>  I am not a lawyer, but surely _many_ of the kernel files do not
>> contain any explicit copyright information ?
> On closer inspection, more files than I thought don't have any explicit
> copyrights on them. ~67% of files in v3.13 had the text 'Copyright' or
> 'Licens' appear in them.
>
>>  Why does your editor put a default license on anything ?
> It's my stock header, customized by per-directory vimrc. The
> non-project-specific default one actually has a CHANGEME string it in,
> to help remind me that it needs an edit before I release that file.
> I was just using the BSD license on the file as an example. Submissions
> to other open source projects are generally bound by the license of the
> project, with a few exceptions (I've put patches into public domain to
> avoid signing some CLA-like agreements).
>
>>  If I was being awkward, I would suggest that the config would not
>> be useful until you had run it through "make oldconfig" or similar,
>> and that therefore the kernel license of GPL-2 applies.
> That's the case I was interested in :-).
>
>>> If the files are to be marked with a copyright header, who is the holder
>>> of it that it should be attributed to?
>>  Iff the work is copyrightable (I do not have an opinion on that),
>> surely the license only matters if you breach it ? ;-)  If you
>> distribute a compiled kernel with the source, and all of that source
>> is GPL-2, then I assume you are in the clear.  For "extras" which
>> include binaries without source, my understanding is that you would
>> always be vulnerable to kernel copyright holders.  So, I suspect
>> that the attribution of a config file is not particularly important.
> I agree with your reasoning if I was distributing kernel sources or
> compiled kernels, but this is going to be a package of kernel
> configurations only.
>
>>> Background:
>>> Gentoo has a bunch of "stock" kernel configurations for release
>>> engineering, our initramfs tool (genkernel), and other endeavors over
>>> the years. These projects claim BSD, GPL2, LGPL2 on various pieces, and
>>> I don't think they can all be correct. I'm working on getting them into
>>> one place, because some of them have been getting stale, but the
>>> differing licenses raised a red flag to me.
>>  To the extent that GPL-2 can include LGPL-2 and BSD, I suggest that
>> you label them all as GPL-2.  That is the licence of the kernel, and
>> for practical reasons it will not change (this was discussed when
>> somebody asked about GPL-3 : even if the main copyright holders
>> wanted to make the change (and many do not), some copyright holders
>> are no longer contactable).  You might be able to dual-license some
>> of these distro files, but I have no idea if that would be appropriate.
> If the rest of the logic is correct, then the non-GPL2 license on these
> files was never valid in the first place; they inherited GPL2 from the
> kernel from the get go, and I don't need to be concerned about the
> hassle of formally relicensing them by contacting the authors of the
> configs (which again, aren't always contactable anymore).
>
>
>

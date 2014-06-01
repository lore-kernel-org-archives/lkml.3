Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaFAX3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 19:29:16 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52997 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaFAX3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 19:29:15 -0400
Date: Sun, 1 Jun 2014 23:29:09 +0000
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: linux-kernel@vger.kernel.org, robbat2@gentoo.org
Subject: Re: Licensing & copyright of kernel .config files (defconfig,
 *config)
Message-ID: <robbat2-20140601T231524-149301602Z@orbis-terrarum.net>
Reply-To: linux-kernel@vger.kernel.org, robbat2@gentoo.org,
        zarniwhoop@ntlworld.com
References: <robbat2-20140601T012929-356267352Z@orbis-terrarum.net>
 <20140601230146.GB31939@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140601230146.GB31939@milliways>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 12:01:46AM +0100, Ken Moffat wrote:
> > Naively, since the defconfigs are bundled with the kernel, that could
> > fall under GPLv2-only implicitly, but lacking any explicit copyright
> > headers makes this interesting (arch/*/configs/* contain lots of files,
> > no copyright headers on them).
>  I am not a lawyer, but surely _many_ of the kernel files do not
> contain any explicit copyright information ?
On closer inspection, more files than I thought don't have any explicit
copyrights on them. ~67% of files in v3.13 had the text 'Copyright' or
'Licens' appear in them.

>  Why does your editor put a default license on anything ? 
It's my stock header, customized by per-directory vimrc. The
non-project-specific default one actually has a CHANGEME string it in,
to help remind me that it needs an edit before I release that file.
I was just using the BSD license on the file as an example. Submissions
to other open source projects are generally bound by the license of the
project, with a few exceptions (I've put patches into public domain to
avoid signing some CLA-like agreements).

>  If I was being awkward, I would suggest that the config would not
> be useful until you had run it through "make oldconfig" or similar,
> and that therefore the kernel license of GPL-2 applies.
That's the case I was interested in :-).

> > If the files are to be marked with a copyright header, who is the holder
> > of it that it should be attributed to?
>  Iff the work is copyrightable (I do not have an opinion on that),
> surely the license only matters if you breach it ? ;-)  If you
> distribute a compiled kernel with the source, and all of that source
> is GPL-2, then I assume you are in the clear.  For "extras" which
> include binaries without source, my understanding is that you would
> always be vulnerable to kernel copyright holders.  So, I suspect
> that the attribution of a config file is not particularly important.
I agree with your reasoning if I was distributing kernel sources or
compiled kernels, but this is going to be a package of kernel
configurations only.

> > Background:
> > Gentoo has a bunch of "stock" kernel configurations for release
> > engineering, our initramfs tool (genkernel), and other endeavors over
> > the years. These projects claim BSD, GPL2, LGPL2 on various pieces, and
> > I don't think they can all be correct. I'm working on getting them into
> > one place, because some of them have been getting stale, but the
> > differing licenses raised a red flag to me.
>  To the extent that GPL-2 can include LGPL-2 and BSD, I suggest that
> you label them all as GPL-2.  That is the licence of the kernel, and
> for practical reasons it will not change (this was discussed when
> somebody asked about GPL-3 : even if the main copyright holders
> wanted to make the change (and many do not), some copyright holders
> are no longer contactable).  You might be able to dual-license some
> of these distro files, but I have no idea if that would be appropriate.
If the rest of the logic is correct, then the non-GPL2 license on these
files was never valid in the first place; they inherited GPL2 from the
kernel from the get go, and I don't need to be concerned about the
hassle of formally relicensing them by contacting the authors of the
configs (which again, aren't always contactable anymore).


-- 
Robin Hugh Johnson
Gentoo Linux: Developer, Infrastructure Lead
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11ACBA4F 4778E3F6 E4EDF38E B27B944E 34884E85

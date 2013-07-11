Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750982Ab3GKEZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 00:25:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab3GKEZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 00:25:26 -0400
Date: Wed, 10 Jul 2013 21:26:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>, Jan Beulich <JBeulich@suse.com>,
        dt.tangr@gmail.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        James Hogan <james.hogan@imgtec.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        robert.richter@calxeda.com,
        "Yaakov (Cygwin/X)" <yselkowitz@users.sourceforge.net>,
        zzs0213@gmail.com,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] kbuild changes for v3.11-rc1
Message-ID: <20130711042626.GA23875@kroah.com>
References: <20130710133742.GA29368@emu.suse.cz>
 <CA+55aFxtvT3Yvbxe5JGBThZS13payymFJ7jCLyEiE2iNDvsZtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxtvT3Yvbxe5JGBThZS13payymFJ7jCLyEiE2iNDvsZtQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 07:11:53PM -0700, Linus Torvalds wrote:
> Commit d2aae8477cd00325bb7c7c7e95be488088900c48 is broken. It causes
> root to re-write "include/config/kernel.release".
> 
> There is no excuse for this. That commit is shit. There's no way in
> hell that "make modules_install" should ever rebuild anything, so
> adding that kind of dependency is fundamentally wrong and broken.
> 
> And that totally crap commit is even marked for stable.

It's now dropped from my stable to-apply queue.

greg k-h

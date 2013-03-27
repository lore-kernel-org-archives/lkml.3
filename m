Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3C0SkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 14:40:10 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:38214 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab3C0SkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 14:40:07 -0400
Date: Wed, 27 Mar 2013 11:40:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/98] 3.8.5-stable review
Message-ID: <20130327184004.GA21678@kroah.com>
References: <20130326224242.449070940@linuxfoundation.org>
 <CAKocOOOBPaR5n14522nnYQDTFWOWrpXqc1tN+HLHguTL+b=+_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKocOOOBPaR5n14522nnYQDTFWOWrpXqc1tN+HLHguTL+b=+_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 12:34:28PM -0600, Shuah Khan wrote:
> On Tue, Mar 26, 2013 at 4:41 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 3.8.5 release.
> > There are 98 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu Mar 28 22:41:38 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.8.5-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Patches applied cleanly to 3.0.70, 3.4.37, and 3.8.4
> 
> Compiled and booted on the following systems:
> 
> HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU T9400 @ 2.53GHz
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

Thanks for testing.

> dmesgs for all releases look good. No regressions compared to the previous
> dmesgs for each of these releases.
> 
> Cross-compile tests results:
> 
> alpha: defconfig passed on all
> arm: defconfig passed on all
> arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.8.y
> c6x: not applicable to 3.0.y, defconfig passed on 3.4.y, and 3.8.y.
> powerpc: wii_defconfig passed on all
> sh: defconfig passed on all
> sparc: defconfig passed on all
> tile: tilegx_defconfig passed on all
> 
> Known issue since 3.0.70, 3.4.37 and 3.8.4
> 
> kernel/signal.c: In function ‘flush_signal_handlers’:
> kernel/signal.c:441:9: error: ‘struct sigaction’ has no member named
> ‘sa_restorer’
> make[1]: *** [kernel/signal.o] Error 1
> make: *** [kernel] Error 2
> 
> mips: defconfig failed
> mipsel: defconfig failed

Yeah, I really should fix that... :)

greg k-h

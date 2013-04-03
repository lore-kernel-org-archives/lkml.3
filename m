Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992Ab3DCP2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:28:06 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:58123 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760282Ab3DCP2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:28:03 -0400
Date: Wed, 3 Apr 2013 08:28:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 000/124] 3.8.6-stable review
Message-ID: <20130403152800.GB21643@kroah.com>
References: <20130402221104.163133110@linuxfoundation.org>
 <CAKocOON7pmk5gFXA1Gq9Fx06jEWxSMx07kZXcrOLz9n-HcyZKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKocOON7pmk5gFXA1Gq9Fx06jEWxSMx07kZXcrOLz9n-HcyZKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 09:17:33AM -0600, Shuah Khan wrote:
> On Tue, Apr 2, 2013 at 4:09 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 3.8.6 release.
> > There are 124 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu Apr  4 22:09:55 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.8.6-rc1.gz
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Patches applied cleanly to 3.0.71, 3.4.38, and 3.8.5
> 
> Reviewing patches - will let you know anything odd.
> 
> Compiled and booted on the following systems:
> 
> HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU T9400 @ 2.53GHz
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
> 
> dmesgs for all releases look good. No regressions compared to the
> previous dmesgs for each of these releases.
> 
> mips compile problem fixed
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
> mips: defconfig passed on all
> mipsel: defconfig passed on all

Thanks for testing, and confirming that I got the build problem fixed.

greg k-h

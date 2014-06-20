Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967603AbaFTNj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:39:27 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:37704 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965897AbaFTNj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:39:26 -0400
Date: Fri, 20 Jun 2014 14:39:19 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matt Fleming <matt@console-pimps.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EFI urgent fix
Message-ID: <20140620133919.GK4179@bivouac.eciton.net>
References: <20140620090008.GU24049@console-pimps.org>
 <20140620092848.GC23939@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620092848.GC23939@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:28:48AM +0100, Catalin Marinas wrote:
> On Fri, Jun 20, 2014 at 10:00:08AM +0100, Matt Fleming wrote:
> > Please pull the following compiler warning fix. Sorry, I've been pretty
> > slow in getting this pull request sent. Multiple people have reported
> > hitting it and I've now received 4 patches for the same warning,
> 
> BTW, one of them is not just a simple warning but a bug. Pointer to
> "long" variable on the stack passed to a function that only takes a
> pointer to "int". We are probably lucky that we don't hit the bug on
> arm64.
> 
> Anyway, thanks for pushing the fix.
> 
> (and lesson learnt not to trust the ARM EFI_STUB developers, won't name
> them, with properly testing their code ;))

The code was tested and showed no runtime problems - but I did manage
to miss the warnings.

I did post an alternative patch for one half of this a week before
anyone else, but that one seems to have been ignored, even by gmane:
http://www.spinics.net/lists/linux-efi/msg03924.html

That form will still be required for the 32-bit arm support, since
strncmp is not available in the zImage.

/
    Leif

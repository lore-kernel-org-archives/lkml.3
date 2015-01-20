Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbbATULI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:11:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbbATULG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:11:06 -0500
From: Paul Moore <pmoore@redhat.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        Boaz Harrosh <openosd@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-audit@redhat.com,
        viro@zeniv.linux.org.uk, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount root fs
Date: Tue, 20 Jan 2015 15:10:46 -0500
Message-ID: <6975799.ujoFD1RpCy@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <CAOMZO5DsKT2rbSs8PuM6+KYcHZ6165-9eJPDXz=LJxiLW1tb-A@mail.gmail.com>
References: <20150120185308.53f4af4e@canb.auug.org.au> <129259164.tYuuyxyNUx@sifl> <CAOMZO5DsKT2rbSs8PuM6+KYcHZ6165-9eJPDXz=LJxiLW1tb-A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 20, 2015 05:43:01 PM Fabio Estevam wrote:
> On Tue, Jan 20, 2015 at 5:24 PM, Paul Moore <pmoore@redhat.com> wrote:
> > On Tuesday, January 20, 2015 05:16:45 PM Fabio Estevam wrote:
> >> On Tue, Jan 20, 2015 at 5:00 PM, Ross Zwisler
> >> 
> >> <ross.zwisler@linux.intel.com> wrote:
> >> > These were just nuisance warnings, I believe, so my guess is that this
> >> > isn't related to your kernel panic.   Reverting Boaz's patches to make
> >> > these warnings go away would let you know for sure.
> >> 
> >> You are right. Reverting 937af5ecd0591e makes such warnings disappear.
> > 
> > You guys are much quicker compiling kernels than I am :)
> > 
> > Fabio, are you still seeing the same panic, just without the warnings?  Or
> > has the panic resolved itself as well?
> 
> Just to clarify: I was not getting the same panic Sabrina originally
> reported.
> 
> Reverting 937af5ecd0591e made the ram warnings go away.
> 
> On my case I am running linux-next 20150120 plus this fix:
> http://www.spinics.net/lists/arm-kernel/msg393205.html
> 
> and things seem to boot fine here on my ARM platform.

Okay, thanks for the clarification; glad you got it working.

-- 
paul moore
security @ redhat


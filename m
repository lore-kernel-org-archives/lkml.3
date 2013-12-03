Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3LCKmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 05:42:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49582 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab3LCKmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 05:42:10 -0500
Date: Tue, 3 Dec 2013 10:42:06 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ubuntu kernel team <kernel-team@lists.ubuntu.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Linux 3.11.y.z extended stable support
Message-ID: <20131203104206.GA5058@hercules>
References: <20131202154329.GC1799@hercules.my.domain>
 <CA+5PVA4X+OV3L5oKL1XoPQ4=9pi_wd6MwMaSuqjyy57pAapxxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4X+OV3L5oKL1XoPQ4=9pi_wd6MwMaSuqjyy57pAapxxw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On Mon, Dec 02, 2013 at 02:58:31PM -0500, Josh Boyer wrote:
> On Mon, Dec 2, 2013 at 10:43 AM, Luis Henriques
> <luis.henriques@canonical.com> wrote:
> > Since Ubuntu 13.10 "Saucy Salamander" uses the 3.11 kernel, the Ubuntu
> > kernel team will pick up stable maintenance where Greg KH left off[1]
> > with 3.11.10 (thanks a lot, Greg!).
> >
> > The Ubuntu kernel team is pleased to announce that we will be
> > providing extended stable support for the Linux 3.11 kernel until
> > August 2014 as a third party effort maintained on our infrastructure.
> >
> > Our linux-3.11.y{-queue,-review} stable branches will fork from
> > 3.11.10 and will be published here:
> >
> >     git://kernel.ubuntu.com/ubuntu/linux.git
> >
> > We will use the same stable request/review workflow and follow the
> > standard upstream stable kernel rules.  More details are available at
> > http://wiki.ubuntu.com/Kernel/Dev/ExtendedStable
> >
> > We welcome any feedback and contribution to this effort.  We will be
> > posting the first review cycle patch set in a week or two.
> 
> I might have asked this already before, but if I did I've forgotten
> the answer.  Apologies if so.
> 
> Why not do this on the kernel.org infrastructure and treat it like all
> the other kernel.org stable releases?  I'm confused why it needs to be
> "forked" when it's following the same rules.  It seems like it could
> just pick up with 3.11.11 and carry on.

I would be more than happy to maintain the 3.11 kernel using Greg's
official stable git repository (e.g., by sending him a pull request).
However, I believe this has been proposed in the past without
success.

Anyway, we're still open to change this.  Greg, please let me know if
you would like to have the 3.11 kernel maintained for some more time,
or if you rather keep it dead.

Cheers,
--
Luis

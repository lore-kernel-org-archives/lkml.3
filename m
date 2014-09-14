Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaINXMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 19:12:37 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:49199 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaINXMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 19:12:36 -0400
Date: Mon, 15 Sep 2014 00:12:19 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark S <mstanovich15@gmail.com>, linux-kernel@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>,
        Jun Tian <jun.j.tian@intel.com>, Alan Cox <alan@linux.intel.com>
Subject: Re: 3.15 Regression Due to goldfish bus Commit
Message-ID: <20140915001219.63fb91dd@alan.etchedpixels.co.uk>
In-Reply-To: <20140914215737.GA945@kroah.com>
References: <CAPC5HRoW4pdMhBrJfQ40ZnJoon+zCRtAnZzzgEExw4ks=Trr2g@mail.gmail.com>
	<20140914215737.GA945@kroah.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Sep 2014 14:57:37 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Sun, Sep 14, 2014 at 05:38:55PM -0400, Mark S wrote:
> > Commit c1bc97f8f498a2bfab63ceef761fb0e88ef7c065 causes a gateway x86 laptop,
> > booting from a usb device, to hang before the kernel completes booting. The
> > offending commit was found using git bisect. Reverting the commit fixes the
> > problem on 3.16.2.
> > 
> > The error resulting in the hang may not be a concern since the goldfish option
> > is not needed and should probably not be selected. I'm mentioning this problem
> > just in case it is unexpected behavior and it is worth fixing. Maybe the
> > goldfish option should not be selectable for a similar configuration as mine?
> 
> There should be some other type of run-time option to not have this code
> run if it is found to not be running on the goldfish virtual machine.
> 
> Anyone know how to do that?

I asked last time it was reported and the time before (it comes up every
year or two). There is no sane documented way to detect the Goldfish
virtual machine as distinct from anything else.

We could hide Goldfish under expert ?

Alan

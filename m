Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3J2UB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:01:57 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:35558 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3J2UBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:01:55 -0400
Date: Tue, 29 Oct 2013 21:01:51 +0100
From: Robert Richter <rric@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-edac@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 0/5] edac, highbank: Add Calxeda ECX-2000 support
Message-ID: <20131029200151.GC7429@rric.localhost>
References: <1381921178-28511-1-git-send-email-rric@kernel.org>
 <CAL_JsqJXg=76rnTe6rcaQsvycNZOc7hDdP3jpVPYbjzwbssDfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJXg=76rnTe6rcaQsvycNZOc7hDdP3jpVPYbjzwbssDfg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.10.13 17:06:07, Rob Herring wrote:
> On Wed, Oct 16, 2013 at 5:59 AM, Robert Richter <rric@kernel.org> wrote:
> > This patch series enables ECC edac support for Calxeda ECX-2000
> > (Midway). The ECX-2000 memory controller is similar to Highbank but
> > has different register bases for error and interrupt registers.
> >
> > Testing the driver uncovered a bug in the interrupt initialization.
> > So there is also a fix for this for all the Highbank edac drivers. The
> > interrupt was enabled too early which caused a crash if there are
> > interrupts pending (ECC errors) during driver initialization.
> >
> > Also some improvements and unification of edac log messages I found
> > useful.
> >
> > -Robert
> >
> >
> > Rob Herring (1):
> >   ARM: dts: calxeda: move memory-controller node out of ecx-common.dtsi
> >
> > Robert Richter (4):
> >   edac, highbank: Fix interrupt setup of mem and l2 controller
> >   edac, highbank: Add Calxeda ECX-2000 support
> >   edac, highbank: Improve and unify naming
> >   edac: Unify reporting of device info for device, mc and pci
> 
> For the series:
> 
> Acked-by: Rob Herring <rob.herring@calxeda.com>

Thanks Rob and Boris, I applied the patches here:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git edac

and will take care of them and send a pull request directly to Linus.

-Robert

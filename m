Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaLDKs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:48:29 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46858 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaLDKs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:48:27 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Mark Brown <broonie@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com, Al Stone <al.stone@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1926483.B4ieFnCBlM@vostro.rjw.lan>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org>
	<2580837.YI0IvfXqRR@vostro.rjw.lan> <20141125202722.GA25261@sirena.org.uk>
	<1926483.B4ieFnCBlM@vostro.rjw.lan>
Date: Thu, 04 Dec 2014 10:48:19 +0000
Message-Id: <20141204104819.25015C40992@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 22:40:53 +0100
, "Rafael J. Wysocki" <rjw@rjwysocki.net>
 wrote:
> On Tuesday, November 25, 2014 08:27:22 PM Mark Brown wrote:
> > 
> > --ReaqsoxgOBHFXBhH
> > Content-Type: text/plain; charset=us-ascii
> > Content-Disposition: inline
> > 
> > On Tue, Nov 25, 2014 at 09:31:27PM +0100, Rafael J. Wysocki wrote:
> > > On Tuesday, November 25, 2014 11:07:06 AM Darren Hart wrote:
> > 
> > > > This is a current topic with the ACPI working group. We have the
> > > > following document:
> > 
> > > > http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> > 
> > > This hasn't been discussed a lot at the meetings I attended.
> > 
> > > The bindings management process is being set up within the UEFI Forum, but I'm
> > > not sure if/how the existing DT bindings documented in the kernel tree are
> > > going to be covered by it ATM.
> > 
> > Al Stone (CCed) pointed me at the following two documents:
> > 
> > http://www.uefi.org/sites/default/files/resources/web-page-v2.pdf
> > http://www.uefi.org/sites/default/files/resources/nic-request-v2.pdf
> > 
> > (the first one being the actual process in so far as it exists).  The
> > process appears to be to mail requests in a specific format to the ASWG
> > chairperson (the address is apparently supposed to be awsg@uefi.org).
> > It looks like all the properties are expected to end up in one or more
> > PDF files like the second one.
> > 
> > My initial thought would be to require that we send any DT properties
> > defined for devices with ACPI identifiers registered there and hope the
> > volume doesn't DoS them.
> 
> We absolutely need to start registering the existing bindings in there, but
> that needs to be rate limited somehow, because the process may not be very
> efficient to start with.

Beyond having the document point to the existing DT binding
documentation, I think this is a non-starter. It won't be helpful for
anyone to have two separate repositories containing the same bindings.
They will get out of sync and we will have pain as a result.

For existing bindings we need to have a way to share the documentation,
and I don't think we can even talk about whether it makes sense to
migrate the documetation to the UEFI managed repo before the UEFI process is
fully flushed out.

g.

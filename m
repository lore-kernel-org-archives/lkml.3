Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaKYVTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:19:40 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53247 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751409AbaKYVTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:19:39 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mark Brown <broonie@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com, Al Stone <al.stone@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
Date: Tue, 25 Nov 2014 22:40:53 +0100
Message-ID: <1926483.B4ieFnCBlM@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141125202722.GA25261@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org> <2580837.YI0IvfXqRR@vostro.rjw.lan> <20141125202722.GA25261@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 25, 2014 08:27:22 PM Mark Brown wrote:
> 
> --ReaqsoxgOBHFXBhH
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> 
> On Tue, Nov 25, 2014 at 09:31:27PM +0100, Rafael J. Wysocki wrote:
> > On Tuesday, November 25, 2014 11:07:06 AM Darren Hart wrote:
> 
> > > This is a current topic with the ACPI working group. We have the
> > > following document:
> 
> > > http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> 
> > This hasn't been discussed a lot at the meetings I attended.
> 
> > The bindings management process is being set up within the UEFI Forum, but I'm
> > not sure if/how the existing DT bindings documented in the kernel tree are
> > going to be covered by it ATM.
> 
> Al Stone (CCed) pointed me at the following two documents:
> 
> http://www.uefi.org/sites/default/files/resources/web-page-v2.pdf
> http://www.uefi.org/sites/default/files/resources/nic-request-v2.pdf
> 
> (the first one being the actual process in so far as it exists).  The
> process appears to be to mail requests in a specific format to the ASWG
> chairperson (the address is apparently supposed to be awsg@uefi.org).
> It looks like all the properties are expected to end up in one or more
> PDF files like the second one.
> 
> My initial thought would be to require that we send any DT properties
> defined for devices with ACPI identifiers registered there and hope the
> volume doesn't DoS them.

We absolutely need to start registering the existing bindings in there, but
that needs to be rate limited somehow, because the process may not be very
efficient to start with.

> A more defined format for DT documentation that we can script into the
> ASWG format (or vice versa) might be helpful here, and we should add
> notes to the DT documentation if this is how we want to proceed.

That's a good point.

Unfortunately, the timing is pretty bad (Thanksgiving) and the closest
ASWG meeting is next Thursday, but that one's likely to be busy for other
reasons.  I presume, then, that the earliest we can seriously get back to
that in the ASWG is mid-December.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

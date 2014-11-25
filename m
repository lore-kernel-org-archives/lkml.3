Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbaKYUKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:10:14 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62482 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750863AbaKYUKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:10:13 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
Date: Tue, 25 Nov 2014 21:31:27 +0100
Message-ID: <2580837.YI0IvfXqRR@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5474D35A.3000601@linux.intel.com>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org> <20141125184304.GK7712@sirena.org.uk> <5474D35A.3000601@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 25, 2014 11:07:06 AM Darren Hart wrote:
> 
> On 11/25/14 10:43, Mark Brown wrote:
> > On Tue, Nov 25, 2014 at 10:33:01AM -0800, Darren Hart wrote:
> >> On 11/25/14 09:21, Mark Brown wrote:
> > 
> >>> Given the design of _DSD is to share with DT and we already 
> >>> have device tree bindings for the device we should be using, 
> >>> it's not clear to me if we want to grind them all through UEFI 
> >>> and I suspect they'd be unhappy if we tried but pretty much
> >>> all audio CODECs are good candidates for use with ACPI given
> >>> the new hardware designs Intel have so if we are doing it I
> >>> ought to be bouncing everyone to UEFI forum.
> > 
> >> Right, I realized between sending and driving into the office 
> >> that my statement might be construed this way. I meant *new*
> >> _DSD bindings should go through the ACPI/UEFI forum. Where we
> >> can reuse DT bindings, we should absolutely do that, agreed. We 
> >> should still document this and link to the DT binding so it can 
> >> be referenced and used even when Linux is not the target OS.
> > 
> > Link from where - do we want to talk to the ACPI/UEFI forum and 
> > figure out some kind of fast track process for them to add an
> > "it's already covered by DT, see here" entry to their database for 
> > example?  We also ought to work out how to make sure ACPI IDs are 
> > registered there as well, should be possible to have something 
> > simple as part of that.
> > 
> 
> This is a current topic with the ACPI working group. We have the
> following document:
> 
> http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> 
> I don't know if we want to have a list of them here, or if a separate
> document is needed. The important point is that it is independent from
> the ACPI specification itself so that it can be updated out of band
> with the specification, and not be subject to rather plodding pace
> that would imply.
> 
> Rafael, I've missed several of these meetings unfortunately, and I'm
> not sure if we've closed on this point. Do you know?

This hasn't been discussed a lot at the meetings I attended.

The bindings management process is being set up within the UEFI Forum, but I'm
not sure if/how the existing DT bindings documented in the kernel tree are
going to be covered by it ATM.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

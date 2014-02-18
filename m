Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbaBRPHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:07:42 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57737 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755354AbaBRPHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:07:38 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Peter Weber <bugs@ttyhoney.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kevin Smith <thirdwiggin@gmail.com>,
        Rinat Ibragimov <ibragimovrinat@mail.ru>, sov.info@mail.ru,
        Thomas Christensen <christensenthomas@gmail.com>,
        Vladimir Sherenkov <a_12300@mail.ru>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: Re: [PATCH v4] ACPI / video: Add systems that should favour native backlight interface
Date: Tue, 18 Feb 2014 16:22:27 +0100
Message-ID: <1903167.TtlOFgMB6X@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <s5hfvngy2bh.wl%tiwai@suse.de>
References: <5302F58C.1080001@intel.com> <20140218103442.GS5018@intel.com> <s5hfvngy2bh.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 18, 2014 02:31:46 PM Takashi Iwai wrote:
> At Tue, 18 Feb 2014 12:34:42 +0200,
> Mika Westerberg wrote:
> > 
> > On Tue, Feb 18, 2014 at 01:54:20PM +0800, Aaron Lu wrote:
> > > +	{
> > > +	.callback = video_set_use_native_backlight,
> > > +	.ident = "HP EliteBook 2013 models",
> > > +	.matches = {
> > > +		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> > > +		DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook "),
> > > +		DMI_MATCH(DMI_PRODUCT_NAME, " G1"),
> > > +		},
> > > +	},
> > 
> > I see my device is listed here but the above doesn't really use native
> > backlight because it is still in acpi_osi blacklist. Tried this and I can
> > see both acpi_video0 and intel_backlight listed under /sys/class/backlight.
> > Was this the intention?
> 
> The acpi_osi blacklist commit (2d4054d84224) has to be reverted, as I
> mentioned earlier.  But the revert can be done individually after
> merging this patch.  Rafael, could you care?

Done.  Please check the result in linux-pm.git/linux-next.

Thanks,
Rafael


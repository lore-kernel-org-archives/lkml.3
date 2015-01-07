Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbbAGR2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:28:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41674 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbbAGR2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:28:31 -0500
Date: Wed, 7 Jan 2015 17:27:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robh@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lv Zheng <lv.zheng@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Olof Johansson <olof@lixom.net>
Message-ID: <20150107172741.GY2634@sirena.org.uk>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <2161376.07iV9ANMSk@wuerfel>
 <20150107115039.GA2199@e104818-lin.cambridge.arm.com>
 <1520439.Y1rXzXY1eS@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6ovzACdnYbOKIO0z"
Content-Disposition: inline
In-Reply-To: <1520439.Y1rXzXY1eS@wuerfel>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6ovzACdnYbOKIO0z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 07, 2015 at 02:06:28PM +0100, Arnd Bergmann wrote:
> On Wednesday 07 January 2015 11:50:39 Catalin Marinas wrote:

> > From what I gathered so far, the main reason for _some_ vendors is not
> > support for "other" OS but actually features that ACPI has and DT
> > doesn't (like AML; I deliberately ignore statements like "industry
> > standard"). _If_ such reasons are sound, maybe they have a case for
> > ACPI-only machines targeted primarily at Linux.

> What I got from the replies from HP, Huawei and from earlier discussions
> with Jon is that they all hope to get to the point of relying on AML
> alone to bridge the differences between SoC families. However, I don't
> see that happening with the limited hardware compatibility that the
> existing SBSA provides:

I tend to agree with you that it's an overreach to think that this is
going to completely abstract away the differences between SoCs from
different vendors without substantial further standardization work.
However it does seem reasonable to expect that features like AML are
going to be more successful in handling board differences and
incremental revisions of SoCs - things like interactions with system
power controllers for example.  That seems like a useful win in and of
itself, and one that's worth supporting.

> The main problem here is that can AML only cover part of the problem:
> it can talk to a clock controller e.g. over I2C, SPI, GPIO, UART
> or IPMI, but you still need a device driver in the kernel to talk to
> those, and SBSA doesn't mandate a specific implementation so you can
> expect every other SoC that is coming out to have a different one.

> Similarly, SBSA is rather vague about some peripherals it mandates,
> and if a new SoC has a slightly different AHCI variation, there is
> nothing you can do about it in AML.

> x86 gets around this problem by having an extreme level of hardware
> backwards compatibility, so you don't even need AML for this and
> can generally boot a (almost) full-featured Linux kernel with
> acpi=off on the command line.

That level of hardware compatibility does partly come from the need to
run existing software.  I'd expect that similar effects will start to
come into play with ARMv8 ACPI systems if they become successful; people
will do things like ensure compatibility with common IPs that have
existing Linux drivers that distros tend to include as standard.

--6ovzACdnYbOKIO0z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrWyMAAoJECTWi3JdVIfQGAUH/jml1p4+VJ2rwtT9ED9KKG9X
vPSgeXHmg89xk7HkqYLG3rcd8QS/wErEbfdM9f5tGuqPwiYSrvldm6XjK2k8gkhm
GcWfD85Sle8yziONh2qHeVvMaHCzpzAAWYaeK9jdehmoPW6COG/sduc4jnET+Bb2
Xf7enQgYXBRxowtFIoswdJir/p3q+tPS9Nw98l1/lwEKsyOIgqzjzLSz/asxt4/v
k9uZ1Z8c6KS2U273YhfFyNmsSCyUszdXX3rPUgU76eMFtgYGka2uBuPJYGJvcfNj
3x4jBAqSInsuwmgaapqfI7enjG4L/Brh7uPjuzr2ujY0HYJDrbSRDTV3sR6ReKc=
=hgdU
-----END PGP SIGNATURE-----

--6ovzACdnYbOKIO0z--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbbAPQzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:55:25 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39885 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbbAPQzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:55:23 -0500
Date: Fri, 16 Jan 2015 16:54:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Yijing Wang <wangyijing@huawei.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-acpi <linaro-acpi@lists.linaro.org>
Message-ID: <20150116165422.GE3856@sirena.org.uk>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com>
 <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
 <20150115190220.GF3043@sirena.org.uk>
 <20150115200437.GF24989@titan.lakedaemon.net>
 <20150116101034.GC13634@e104818-lin.cambridge.arm.com>
 <20150116120518.GK3043@sirena.org.uk>
 <20150116122922.GO7091@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="k3qmt+ucFURmlhDS"
Content-Disposition: inline
In-Reply-To: <20150116122922.GO7091@arm.com>
X-Cookie: I've Been Moved!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k3qmt+ucFURmlhDS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 16, 2015 at 12:29:22PM +0000, Will Deacon wrote:
> On Fri, Jan 16, 2015 at 12:05:18PM +0000, Mark Brown wrote:

> > Actually, another thing that might help would be if you and/or Will were
> > to prod the relevant people for review, letting them know that the
> > controversy isn't likely to affect their bits.

> Hmm, we *could*, but having maintainers go round poking other people to
> review patches feels like the wrong way round to me. The authors should
> be taking ownership of this series and that's half of the problem we
> had in previous versions.

> It needs to be clear that Hanjun/Al/Graeme are the ones running the show,
> not just now, but (even more importantly) when people start building on
> top of the base support. If Catalin and I have to go around asking for
> review, it sets us off on the wrong foot imo.

That's true in general but equally right now it's also fairly clear that
this isn't going anywhere immediately (and one might assume potentially
may end up needing substantial rework) for arm64 related reasons which
creates a bit of stop energy that's more easily unblocked by the arm64
maintainers than others.  From that point of view I guess just giving
the ACPI folks something to point at to indicate that the remaining
issues on the architecture side aren't likely to affect the relevant
code would probably help also.

--k3qmt+ucFURmlhDS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUuUI+AAoJECTWi3JdVIfQbhoH/0fmqLEKaN55GiCchLinunXH
3CowG6cR8Rvx1t1XGZVq5LciTV/BwZ2IFCWVlDUrtuUyeahXPOnyK4rJ1AVD5u21
FKj4EyuFh8pF2FQTEztQ5ZKKt6zVVwvU21OVA/YryZl35g+Qp0JfUyyq5gziGVXh
b7GOT1XagEdIGvfOyxekbFcjWkXUAmA3uz5wVgjg0DY3esQgpF51KbL3VrZFss5f
8h7sKOHKsRGzIhLBBj1v2OUFm8LAYEMASkOm/7BJHsQOj7b19QINCELxoUoVSXj1
vvC1VfSnHfy0ikdSxSFu0GfdcZQvadanddVoQsC4RnuI1EQ9FfjkL3+IMY4LmpA=
=LtRT
-----END PGP SIGNATURE-----

--k3qmt+ucFURmlhDS--

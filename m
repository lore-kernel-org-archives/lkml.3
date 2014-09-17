Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbaIQRDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:03:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48279 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbaIQRDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:03:54 -0400
Date: Wed, 17 Sep 2014 10:02:35 -0700
From: Mark Brown <broonie@kernel.org>
To: Jon Masters <jcm@redhat.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Charles.Garcia-Tobin@arm.com, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>
Message-ID: <20140917170235.GP7960@sirena.org.uk>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <1410530416-30200-19-git-send-email-hanjun.guo@linaro.org>
 <20140917014410.GC31214@srcf.ucam.org>
 <54194D22.7060706@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U3jK8g368jZ6I4TC"
Content-Disposition: inline
In-Reply-To: <54194D22.7060706@redhat.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 18/18] Documentation: ACPI for ARM64
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U3jK8g368jZ6I4TC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2014 at 04:58:10AM -0400, Jon Masters wrote:
> On 09/16/2014 09:44 PM, Matthew Garrett wrote:

> >> +http://www.uefi.org/sites/default/files/resources/_DSD-implementation=
-guide-toplevel.htm

> > How are individuals/companies who aren't UEFI members supposed to do=20
> > this? Aren't there IP issues involved in taking submissions from=20
> > non-members?

> Obviously, I'm not a lawyer, but I would note that the _DSD bindings
> aren't going into the core ACPI document. I think the specifics for non
> members of the UEFI to potentially contribute bindings need to be
> addressed. That said, at this point, the population of the UEFI forum is
> very well aligned with initial players (that this is the case is not
> entirely an accident, I went around to a few folks a year or so ago and
> made sure that they had become members in anticipation of this issue).

Are you sure you've covered all the vendors of off-SoC components who
might be involved?  That's certainly already an issue with people doing
x86 machines (who aren't being bound by this spec but as a subsystem
maintainer how am I supposed to tell if the target is an ARM or x86
system?).

--U3jK8g368jZ6I4TC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGb6qAAoJECTWi3JdVIfQQpMH/1vpKVWr9byiSMcTqwEoj99S
YvyCkM596Ybj9n6tKfRnA6pPQZ61KkDYB8p/TTRxbXFAWF6WwouC26DugEbrPftp
hAC6fkzW2WhqMQ4TjvfIYeq5/kxVE4B3+XmjFnwOealqkUxvgpfpDxs9dKwi1TEA
mLi9Xk1k0orGSjtzCHx30Fbzydad4EAWAtz6byePzD/YUjRL6VgS5ewP1/ZclkHe
fPWzvOKe58XBf+nXlTsNy+2OS4uew3h9gvbnG7ilna9QeYKbuf/AR430LXoicjM7
fW0Mx93gy5PnyUWnqvT7yfHx8iiSLzmudmDYTdEt8L9VNRHYgi4A32ABkKERLaI=
=tvMO
-----END PGP SIGNATURE-----

--U3jK8g368jZ6I4TC--

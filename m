Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbbAOSBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 13:01:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34600 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbbAOSBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 13:01:18 -0500
Date: Thu, 15 Jan 2015 18:00:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-acpi@lists.linaro.org, Jon Masters <jcm@redhat.com>,
        Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>
Message-ID: <20150115180033.GE3043@sirena.org.uk>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <CACxGe6tjiE6u8i-1PHYzX2cOhxJkYN3cV9mqhCHRSMRdOQRfzg@mail.gmail.com>
 <54B7E21E.2000901@redhat.com>
 <2277974.2klgILPa2Q@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2+IiqX0tbFQDLF7Q"
Content-Disposition: inline
In-Reply-To: <2277974.2klgILPa2Q@wuerfel>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2+IiqX0tbFQDLF7Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2015 at 05:52:31PM +0100, Arnd Bergmann wrote:
> On Thursday 15 January 2015 10:51:58 Jon Masters wrote:

> > It gets worse. There *will* be large numbers of ACPI only ARM servers
> > landing over the coming year. Not only would DT code be untested, but
> > insisting on keeping e.g. a DSDT and DT in sync is never going to work
> > anyway. Already we have early stage servers that contain a DT used for
> > bringup that is subsequently not being updated as often as the ACPI
> > tables (those systems are now booting exclusively in labs with ACPI).
> > Eventually, I am going to push for the DT data to be removed from these
> > systems rather than have out of date unmaintained DT data in firmware.

> We will of course be able to relax the rule once ACPI has stabilized on
> ARM64. At the moment, we haven't even agreed on how to represent basic
> devices, so things are in flux and there is no way for a BIOS writer
> to ship an image that we will guarantee to support in the long run.

> At some point after we are reasonably sure we are able to keep supporting
> all existing systems that are working with that kernel, we can take
> support for new systems without having DT by default, and also support
> booting those without acpi=force, which is related to this question.

Speaking with my subsystem maintainer hat on (admittedly not subsystems
affected too much by ARM servers so take this with a pinch of salt) this
just sounds like it's making more work for me - it means having to force
people to write DT code and bindings which I'm then going to have to
review and none of us really care about.  Realistically I'm just going
to take the code if a lack of a DT binding is the only option, I suspect
others will be similar.

--2+IiqX0tbFQDLF7Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUuABAAAoJECTWi3JdVIfQPWQH/020gT9BIRjV1N4Ux3qm3DCT
bJrBVHhVXf+nDskwUVdJGphppqydB3OWEdyi0dwUCHfbqn8YfFkqHoPUuYunOGXA
L93tN0CXbZdih+/ArF8eWjfnZNhtQpPVQD1YjLEwQ4Aif4xVVizZxGx+hwQx8t2K
zRXzttg7Ri8tCfRF0fm3lqoQx3LsYXgov456/9nD6tpWbzmHUMScp1zXq1nBn3QK
FGxEeNTS3NviXYdDyq0ug3FqUKyLtooLVyGBgx2mWbHJEeEtlS6WO0hK85G2fZEz
3vNZdb6MfjrqJ2XM8arbjjoBgrALjlsBpKJ2M1LM0O+w+AXBqzP0lXVf7WJYGwU=
=MBIX
-----END PGP SIGNATURE-----

--2+IiqX0tbFQDLF7Q--

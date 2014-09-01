Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbaIASNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 14:13:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45178 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaIASM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 14:12:58 -0400
Date: Mon, 1 Sep 2014 19:11:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Message-ID: <20140901181152.GL29327@sirena.org.uk>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org>
 <1409583961-7466-2-git-send-email-hanjun.guo@linaro.org>
 <20140901170447.GF608@arm.com>
 <21764799.KDNDm9XRax@wuerfel>
 <20140901173245.GM2953@xora-haswell.xora.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RVLHdg3qhy1T2deX"
Content-Disposition: inline
In-Reply-To: <20140901173245.GM2953@xora-haswell.xora.org.uk>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH for Juno 1/2] net: smsc911x add support for probing
 from ACPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RVLHdg3qhy1T2deX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 01, 2014 at 06:32:45PM +0100, Graeme Gregory wrote:

> This will of course most likely be replaced by _DSD values. I just
> hardcoded for now as _DSD is not yet in the kernel and issues around
> maintenance of bindings are not solved (unless this happened at KS where
> I was not present).

Not really.  AIUI the official thing is still some combination of
getting a DT binding defined and then use that verbatim (as the x86
embedded people want to though I'm still not clear that the Windows
people are on board with this) and the UEFI processes.  It's possible I
misunderstood though.

Realistically if something is usable on x86 embedded it's going to be
supported on ARMv8 servers too unless we jump through hoops, and even
there real implementations in the wild will probably win out.

--RVLHdg3qhy1T2deX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBLblAAoJELSic+t+oim9hKMQAITYUj30XtkLsl/9LaN77WvK
VnHLoAAIv3NSZbFkT4wUCyM7j4YtXWaEPqoiPybEfgYbM7GwdJw2RBlnByFT/3/Q
cpuBu+CJCrXTlh1RhIKchug8y03V3+MZOCQ/TST3VNOdRvEi62f6fMRl62g5m+IW
0FtzGJ+6jsqZjUeYucvyZVjik8P5qN5Yg5g/TSVTxy7IRH9pG8cAVlR95ItFuRFr
WHbRNYqKm7JAxbgm/App4iCwf9SH/6ksZr/xKaP6lZ5hA2Ys6SC29aikUDCYJJB3
Z8YdMKl9SlirT3JBnSGWZZPSAOsNT0RBIPfRXcvhWThbYImXAsHZov7qJMhF36Ni
kh0qgZjF2hLpmVi6GFbuZ7zLD7bWGwuttKyq/gR0B6VekHqLFjc3P+8M+5wp4uXo
5+LupT11dzcimrJ2inYDqaPDaYPcej5cFDkR91N4oGe3WDxmNQi6MsenqVn5sYTv
EiSHm1Rx2vn959OXiKhxdrZIrhb9OOlzk+a/slvea0hFNLSj42mc374QJn4vIPMY
m1R8XkJ26ASEglZlXx8R6TscKUq7TczAZRBb7TO83c3Y1wpDC6VOI9QjN3A+qmnh
6LMzNwkZLvJvtak5Cyvj+8GReSMTNsgInMQ8zmUWxMiDfKaLI+4mvzWIxoxXYhrn
HktXligdz5WB0/o2z2uB
=iLQb
-----END PGP SIGNATURE-----

--RVLHdg3qhy1T2deX--

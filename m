Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaGJMPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:15:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57438 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaGJMPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:15:48 -0400
Date: Thu, 10 Jul 2014 14:12:10 +0200
From: Mark Brown <broonie@kernel.org>
To: Keerthy <j-keerthy@ti.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, mark.rutland@arm.com, galak@codeaurora.org,
        robh+dt@kernel.org, linux@arm.linux.org.uk, balbi@ti.com,
        tony@atomide.com, kishon@ti.com
Message-ID: <20140710121210.GF30458@sirena.org.uk>
References: <1404884193-20580-2-git-send-email-j-keerthy@ti.com>
 <1404901379-30135-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l+LxDeyHMCBjwres"
Content-Disposition: inline
In-Reply-To: <1404901379-30135-1-git-send-email-j-keerthy@ti.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4] regulator: tps65218: Add fixed_uV fields for dcdc5
 and dcdc6
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l+LxDeyHMCBjwres
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 09, 2014 at 03:52:59PM +0530, Keerthy wrote:
> Add fixed_uV fields for dcdc5 and dcdc6.

Applied, but don't bury new patches into the middle of old threads -
it's a good way to get your patch ignored.

--l+LxDeyHMCBjwres
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTvoMXAAoJELSic+t+oim91KgP/3UuZL9YYznaM1SFatPN0ACe
VVEO2KuB72o+u+MVDYoMYE3n7GDOcousFUoT0yFKhjVvnvRIihaleoxZNiBIXyaw
FKqVp0zSSHLKPt4HyE/MZ9t0E14aLhgZ1EE8OyiEfBce+cGxnBnl9X+EGn8cXaqO
x8EEv86Ozvvq0YaaF6VSrhG2ZFtLUZFikrTqui/8IWFEkiwtQmKOaqADQbLlnxNC
M+Exa1ofxBAufd47+JGtkpdYf4e5GESlmY7dJDg7QemEpno1AiLzUEYIrrR5a7ta
EB+pKUDfdstjt9NkJJKmh9iQkfU0vD4lCtgDT53MzuMigdHKamuabwx7TquYSzOY
4I59+ailTITVUzcYgkKjBvUIa6H1txww/Vbct/I+hNHeydw44yeko+JjIYEyZ2U+
/5FlR0x3lA2uPCVrfRDDp8zieqVba5S3+VF1zdUXww36uOW9oF99cQbDPHfrCSsi
P19EjBd6wPsl++AuDNaKKsmgR+evdWh4rpPTnO+o2bqRuhwDI8Oy1Siz9i1UDEYg
8drw4abiykPHTjCFKeCeF/yGZYZfiuzlzHJcywwjLsSGtGGxOFFvfN3EqwRyZcu5
5F7V/7RyrJKW1bGPBdoBiuSlpuB+3UCszEN7FnZ3mgsI8BeD/PCN8cVESra/+FVe
tDfbpL+scmBHSLkcxRc4
=2YNl
-----END PGP SIGNATURE-----

--l+LxDeyHMCBjwres--

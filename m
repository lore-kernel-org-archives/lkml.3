Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbaJGTM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:12:29 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39194 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbaJGTM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:12:28 -0400
Date: Tue, 7 Oct 2014 20:12:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Ben Zhang <benzh@chromium.org>
Cc: alsa-devel@alsa-project.org, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>, linux-kernel@vger.kernel.org
Message-ID: <20141007191212.GF4609@sirena.org.uk>
References: <1412372246-10489-1-git-send-email-benzh@chromium.org>
 <1412372246-10489-2-git-send-email-benzh@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eqq5Le9VNi5o1NaU"
Content-Disposition: inline
In-Reply-To: <1412372246-10489-2-git-send-email-benzh@chromium.org>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] ASoC: rt5677: Add ACPI device probing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eqq5Le9VNi5o1NaU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 03, 2014 at 02:37:25PM -0700, Ben Zhang wrote:

> +#ifdef CONFIG_ACPI
> +		.acpi_match_table = ACPI_PTR(rt5677_acpi_id),
> +#endif

Why do you need this ifdef - surely the whole point of ACPI_PTR() is to
avoid needing it?

--eqq5Le9VNi5o1NaU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNDsMAAoJECTWi3JdVIfQQ/UH/1Ea+AKUABMRrUT4UuM/KqtF
6IgKFezy+hhK6sv5eAEZMADk82HFX29+hT3E9AKGgFu+Su5tiU3EBBz9+powcmIH
hpkuoOaMXAa7/fGmC5ZcQbobD6+NJljctYj5/QxH1dYRMbPbfy2vf/j4bLn82dx/
0/3shmZFvny9Emsx0JTxTNqug0xUE1Sl77/FDUwzu9b8v9yH0FYXFYglLahQ3hXt
l2WToSTegqaXB0xc06DqXKYIB4BiqreSWoOjgu0wF4rNxLHJYmtzjyuobM4AbwfT
0SvvwJzQyomTj8sWgKpzJ8Kt3xfoJCQDbdmjCZX29gRaABa88jVPEvCKbpsCC2o=
=e2bE
-----END PGP SIGNATURE-----

--eqq5Le9VNi5o1NaU--

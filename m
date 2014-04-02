Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbaDBJPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 05:15:15 -0400
Received: from mail4.gandi.net ([217.70.183.210]:35124 "EHLO mail4.gandi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147AbaDBJPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 05:15:12 -0400
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2014 05:15:12 EDT
Date: Wed, 2 Apr 2014 11:06:24 +0200
From: William Dauchy <william@gandi.net>
To: Borislav Petkov <bp@alien8.de>
Cc: William Dauchy <wdauchy@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        "tglx@linutronix.de" <tglx@linutronix.de>, Tony <tony.luck@intel.com>,
        Gong <gong.chen@linux.intel.com>, linux-tip-commits@vger.kernel.org,
        William Dauchy <william@gandi.net>
Subject: Re: [tip:x86/urgent] x86, CMCI: Add proper detection of end of CMCI
 storms
Message-ID: <20140402090624.GT22251@gandi.net>
References: <tip-27f6c573e0f77f7d1cc907c1494c99a61e48b7d8@git.kernel.org>
 <CAJ75kXZbvs2mGRQod0df5Xs_AcodsQ=n+030tYawQDrFW01Y2Q@mail.gmail.com>
 <20140402090132.GA16033@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7WENQHN97/U9vH7R"
Content-Disposition: inline
In-Reply-To: <20140402090132.GA16033@pd.tnic>
Reply_to: William Dauchy <william@gandi.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7WENQHN97/U9vH7R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Apr02 11:01, Borislav Petkov wrote:
> It is too late for that now as the patch is in -tip already... Unless
> Ingo can still amend it, that is.
>=20
> But, we're working on a real solution for the storm issue and there
> we'll be asking you to test stuff anyway so we'll make sure to use this
> mail address then, ok?

ack
--=20
William

--7WENQHN97/U9vH7R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlM70xAACgkQ1I6eqOUidQEyVACfVvF/39MCKkYuNCMaSDVdplEY
zWwAn3iU1OwjDgs1YrEJHHD2GWh+4fCn
=r4Y9
-----END PGP SIGNATURE-----

--7WENQHN97/U9vH7R--

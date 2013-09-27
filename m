Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3I0RFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 13:05:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51132 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752591Ab3I0RFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 13:05:07 -0400
Date: Fri, 27 Sep 2013 20:05:05 +0300
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/5] Allwinner SoCs High Speed Timer support
Message-ID: <20130927170505.GX2954@lukather>
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
 <87zjr04vnh.fsf@linaro.org>
 <CAOesGMhTZS1MdHW9cL4s_X8jUXHS3VkNZupCfX4ZGroL6k4gEw@mail.gmail.com>
 <20130925195012.GI2954@lukather>
 <20130926163942.675266e5@skate>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="22hJjvOmZW2O/jbw"
Content-Disposition: inline
In-Reply-To: <20130926163942.675266e5@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--22hJjvOmZW2O/jbw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Thu, Sep 26, 2013 at 04:39:42PM +0200, Thomas Petazzoni wrote:
> On Wed, 25 Sep 2013 22:50:12 +0300, Maxime Ripard wrote:
>=20
> > For all we know, so far, allwinner has released, by family:
> >   - sun3i (ARM926)
> >     * F20 (not supported)
> >   - sun4i (Cortex A8)
> >     * A10
> >   - sun5i (Cortex A8)
> >     * A10s
> >     * A13
> >   - sun6i (4 * Cortex A7)
> >     * A31
> >     * A31s (not supported)
> >   - sun7i (2 * Cortex A7)
> >     * A20
> >     * A23? (that was just announced)
>=20
> A small update to Documentation/arm/sunxi/README would be nice :)

Yep, right. Even though, for most of these SoCs (F20, A10s, A31*, A2*),
I don't think we have publicly available datasheet to point to there.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--22hJjvOmZW2O/jbw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSRbrBAAoJEBx+YmzsjxAgC04QAJQLqnondPvi7JwgWNkUTofj
YukxEyp7qvmQELMeJt9iVlde9bTbBD1Zj66b/g4NsalSF8WgucYxMr7ulstgLnib
vV+fTZJ8OsUPbgWxA6q3rXgcyKvV3p9y8tmc/TZ8F5dwufXfA8kmErQOrHcxY299
Xym/tBScX3QLSyXqLo5F1Y3V2SoIt3p6YQSkRPQFSihKa2fnOGEsx49pzABoG/3d
/p/s+dleaQiInQ7hoXLrPD9UrOUZrfEHdGKoQUnsmTxx2S7nwNiGyQWm1XGk9dtU
bM/VWeAYTBu2Gu8rM8JIohR+Px5J+XuhoGH8qIzbsNl4rxQH6NEoS1D5r+lbZQiH
g3kaSoQq0DWXjsNAH3IwSRr2CmYGarnix+P5RmwyYobtDdjMoFoNFMGFahnUOFVV
q+5GuISnkVMs9/Gcvx+PT8Fe4NaEm/Q3BccNHabZ/DvmpxM143DX92yMMhp6T0qG
OoZCz988knzSlA7MUWLuyleANqkKCT8iiNz88bvzfIeTFCfLgSRC4Rmve/n98MOl
O2U4uwxr75yf6OL9egHCiItaGnW2LUx8W3YR5H/SZFdsCEFW2JW9Foye5xjNDKGu
v/Z+dGf0R3/ehHHe0Qb0yXgJshdOl5abJg4HoGul7gZWAomNkFCK3ZOaxFh4aou5
zrjHn3jh3zk49Afu9q0V
=uSWx
-----END PGP SIGNATURE-----

--22hJjvOmZW2O/jbw--

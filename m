Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaHTSYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 14:24:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57036 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaHTSYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:24:36 -0400
Date: Wed, 20 Aug 2014 13:24:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Griffin <peter.griffin@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, Lee Jones <lee.jones@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <maxime.coquelin@st.com>, <patrice.chotard@st.com>,
        <srinivas.kandagatla@gmail.com>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <peppe.cavallaro@st.com>
Subject: Re: [PATCH v2 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3
 HC
Message-ID: <20140820182405.GD6023@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404541530-27856-1-git-send-email-peter.griffin@linaro.org>
 <1404541530-27856-2-git-send-email-peter.griffin@linaro.org>
 <20140707124627.GG6407@lee--X1>
 <20140722091800.GB8233@griffinp-ThinkPad-X1-Carbon-2nd>
 <20140722145711.GC20588@saruman.home>
 <20140723143323.GA26565@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
In-Reply-To: <20140723143323.GA26565@griffinp-ThinkPad-X1-Carbon-2nd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2014 at 03:33:23PM +0100, Peter Griffin wrote:
> > > > > +	reset_control_assert(dwc3_data->rstc_pwrdn);
> > > > > +
> > > > > +	pinctrl_pm_select_sleep_state(dev);
> >=20
> > pinctrl will select sleep and default states automatically for you.
>=20
> I've left this in v3, as greping around I couldn't see how that could
> happen automatically.
>=20
> Also I just double checked with linusw on irc who confirmed that the
> only state which is ever auto-selected is "default". All other states,
> as well as going back to default state need to be explicitly called.
>=20
> Hope thats ok.

yeah, that's fine. Thanks :-)

--=20
balbi

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9OfFAAoJEIaOsuA1yqRE7ZMP+QFujkPZLmG7pVG6EUWoixnW
83+89d+QhI7lUlofX9cKV51O+xpsk/8bn28KyGwBfpYeKsv29ViSlDP29kBYLSQt
DH1E3v4jgbGhgoHqqJGC+r1CIxGMtfWXo9onIPzpEJublS1tir+YdoGrHWd7nHW4
lQvwLZ5k8MWKmPCjcJQCVBZU8C8SP9sZdf8CXqDsY/aTdnZETX2tvfve3IfMYper
Ap5X4q3HYtSyrPWvbn+abpUWllJWv4yy2exMhKMR1IYD8gFcpEEoHZxK7mmwsdAV
Yx0Gq//MC0lSFTQJvGzewEfNqmIhMWDLGcg/oJOYLnl32u0kuQva/xd67TAZTnAt
QS64OKUoux/gkxhXrggHym+NTXZ9O/s4OQh5m9Y6pe1tLeB+grS23U8eYQBVmYo8
xO96rVPkemgCJB+SR2PPOwvmO23WszkcJvdqtbzyXQ/6SLx2qd2RxTz8DnExfsd7
xcmzduFXEofoM83kIaa4yOQSXGVH1UL+ijqFssK7UVxYe2hWvjxHS4CpxG7BQy9v
N13Ia4mVgfyj76TTldGAiN2fUCuBxI1aW0+U0GX/aexZCyy7h/Bvzn49sjpfMU0h
L++iNPeIsWwKUDjwYq5slEgSF5h7dZmz7Fp4xqfcjO4FVJY1m8+IQQAO3TZzwMQx
r9bPL5oyUM5l9qWnW7Sz
=bvi4
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--

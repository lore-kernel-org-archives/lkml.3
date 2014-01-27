Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbaA0U4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:56:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60396 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbaA0U4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:56:36 -0500
Date: Mon, 27 Jan 2014 20:56:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>
Message-ID: <20140127205627.GD11841@sirena.org.uk>
References: <cover.1390813480.git.moinejf@free.fr>
 <22fafd7e11771ffc25c84ff609d18039f07b7295.1390813481.git.moinejf@free.fr>
 <20140127204302.GY11841@sirena.org.uk>
 <20140127204534.GB15937@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9KMRXrBaLD3S8C0H"
Content-Disposition: inline
In-Reply-To: <20140127204534.GB15937@n2100.arm.linux.org.uk>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] ASoC: tda998x: add DT documentation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9KMRXrBaLD3S8C0H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 27, 2014 at 08:45:34PM +0000, Russell King - ARM Linux wrote:
> On Mon, Jan 27, 2014 at 08:43:02PM +0000, Mark Brown wrote:
> > On Mon, Jan 27, 2014 at 09:34:49AM +0100, Jean-Francois Moine wrote:

> > > +	- audio-ports: one or two values.
> > > +		The first value defines the I2S input port.
> > > +		The second one, if present, defines the S/PDIF input port.

> > I take it these are port numbers on the device and it's not possible to
> > do something like having multiple I2S ports?

> You can feed it with multiple synchronised I2S streams for the additional
> channels.

Ah, I feared as much.  The bindings ought to take account of that
posibility even if the code can't use additional ports yet.  Perhaps
separate properties for I2S and S/PDIF?

--9KMRXrBaLD3S8C0H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5sf4AAoJELSic+t+oim9l+AQAJwZVDa/OoV3JumAi8CZgoT0
rULrwoP9ZkIrI/IdV+YcygDtzE998ulCownvZTSSD1kYPrEafgWKQtPlZzffTX+t
rcINMh0c5J2QTouy7dkCrRsDYJ9YQhiReWuE6PS8fy6GMo4EjI1yTiFydfZ3HLKo
heLHLXzm9+J07dsqqAxe3IlRsgDCUvEewgbwz9M0rUCPH3ENPQw8VjXYSWAdPmpO
8Zqq05YInnd5DSLWPd9mxTjF8QW0Nf+cA4PAVS9wvr7B4grSvT8w55g4LzQIUapo
nkAa4KqT1wHz+ojKcKGH+nujb2TSkZmcsPnzVjAG469kPnDwUrs40x0LvpcteKg2
cesfi98228Bay33jM5f/xcAD4jT7/LUSq7s4uRKVZS+PLA83ysoQ348sci9TxbaA
3oTo74DvZMuDyEfKBAWk5WyfCicRmAst7b+GjfdKXxst9u0YoKagEVDyI85Pf1bn
0/dJIJL+/+XcE3Ghq2JlK2pNBObi/4BBMO/HeV0CVzAA+TzZES8jsGMcex0LW3Lm
JVZDTWB5O72cZtF72cEsrip78VrShXJB/mBRqEzl7iPOeiwwjS9WR8Bb9KL3M/vW
wk23+0+3hsFb1S3k9wZuXhnC/kVYSRYM0TkW54dgd7kT4P6jfQDmRHcNHAZQBSNh
bnAqTJQLt8+VNUkc8JSY
=niaY
-----END PGP SIGNATURE-----

--9KMRXrBaLD3S8C0H--

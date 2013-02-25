Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076Ab3BYNv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 08:51:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44225 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780Ab3BYNv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 08:51:27 -0500
Date: Mon, 25 Feb 2013 13:51:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com, arnd@arndb.de,
        linus.walleij@stericsson.com,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [PATCH 01/35] mfd: ab8500-gpadc: Implemented suspend/resume
Message-ID: <20130225135123.GA28907@opensource.wolfsonmicro.com>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
 <1360933026-30325-2-git-send-email-lee.jones@linaro.org>
 <20130220131912.GB13049@sirena.org.uk>
 <CAPDyKFo0MpP-d7v8v1zwB42sboR3MWT6nUmG=-L0_nayYRY7FQ@mail.gmail.com>
 <20130222103306.GA19796@opensource.wolfsonmicro.com>
 <CAPDyKFpJzuzB_7=eH7iNV69TLOTbdBCTx3CgqPTkianZCctKag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <CAPDyKFpJzuzB_7=eH7iNV69TLOTbdBCTx3CgqPTkianZCctKag@mail.gmail.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 25, 2013 at 10:27:36AM +0100, Ulf Hansson wrote:
> On 22 February 2013 11:38, Mark Brown

> > Are you sure this actually does what you think it does, especially when
> > run on modern kernels?

> Not sure, what you are thinking of more precisely here. Runtime pm has
> been in the kernel for quite some time now.

Yes, thanks - I was aware of that.  The integration between runtime and
system PM has been an area that's had some development though.

> Anyway, to make it a bit clearer, we switch the regulator on/off at
> the runtime suspend/resume callbacks. We want to take similar actions
> in device suspend/resume.
> To accomplish this a pm_runtime_get_sync is done in suspend and vice
> verse in resume, otherwise you can not safely handle the regulator.

Are you absolutely positive that with modern kernels your get actually
resumes the device?

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRK2xQAAoJELSic+t+oim9AlAP/1SbYUfNUAFxaodyggSCdr7v
MT2qTl9ustYH7W3CFrdCOUKvB9sV8mwN5TK2DyJIvaFZ0hTruGOVKvuqQGRbFM+r
LDtH/xAXk56UTOGFvxHpf7clyTtcdbYlthRtAY/j+s04RZL6Mp4H94zOZxiWQMH0
RhYEisyC6c2RCGwZbU9DFMUFgPadvdHWAXDUU3HmrKkwZ8pWHtNR2kUIio+lVE9q
Iv/K69WPEH2inHoa68WLpY9kxIAAkZD7FsGUzVPECPIYsLuvPSEs0OsCt0qTvIUb
1laj6cg+pKRXyp77LsaJlo6dKy7whtjW3kZEbwYf5HH9dDg9d7wKVRraSIQxGJv4
2mnvgYKkvR8T6LlWokbPEF6jY/Y65ZArQlsesEX+rfGUyBbwzcg8hP6RjCS3x846
pTbs2cQQpgrDsFa2VwNQIc2I1xiW4v+/WpFD/6kMoNbhCfRjWAvVRk6Nku8OL+Zl
3VpB71xJN2gaby4OgNCVVSzYQ2D1taVamZU3tSifCpVecXGlN+uM1ul8+Qaa5oH5
2gL0lx+dEVBTw4+IByzokVVwVSlq03+PPLcyWtMZJCWU9IMlZrjhPEfHuQ19fz18
tcZg52CEuFtrTLjg4x9gCQ3+uYBlRaabP4lnltbAdIH1u2equQRyyJZLIUTWOMfP
/KNEwErvNIzoV0Q/aCUo
=7sKR
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--

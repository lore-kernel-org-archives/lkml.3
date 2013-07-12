Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab3GLLCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:02:24 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:54293 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab3GLLCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:02:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mark Brown <broonie@kernel.org>, Bin Gao <bin.gao@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: i2c: introduce i2c helper i2c_find_client_by_name()
Date: Fri, 12 Jul 2013 13:02:56 +0200
Message-ID: <1899733.ozqpzoazFs@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <20130712110047.GA3135@katana>
References: <20130606183346.GA13259@bingao-desk1.fm.intel.com> <CAHp75VeasHGariq=v005NSUTe_+e471NYbEoSzPJXcFNgsfKNQ@mail.gmail.com> <20130712110047.GA3135@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7896866.9i7YIXmRqC"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart7896866.9i7YIXmRqC
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday 12 July 2013 12:00:47 Wolfram Sang wrote:
> > Briefly looking into ACPI tables we have and mechanisms that we can
> > use in ACPI case, I doubt we may apply all the ideas, probably some of
> > them, though I didn't get yet where to read about in details. What I
> > could say now is that the patch provided by Bin Gao is definitely no
> > go.
> 
> Laurent explained to me what V4L did and now does. It used to be the way
> tha V4L drivers did register I2C slaves according to platform_data. Now,
> with DT the slaves get instanciated earlier, so they now use notifiers
> to know when the slaves are in place. Something like this should
> probably be done here, too, instead of unregistering and re-registering.

This will be available in v3.11 in drivers/media/v4l2-core/v4l2-async.c.

-- 
Regards,

Laurent Pinchart

--nextPart7896866.9i7YIXmRqC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAABAgAGBQJR3+JgAAoJEIkPb2GL7hl14ugH/j+Mw8QncwOfqDwa+NpqzX/H
16fmoTPCi2EufBs2zREShHY/20/r6fflXM6r3zapKwSTF4HLWRCjEc6MR5JInMMk
cOnG9MN7e1PJRql5G13oflXdobTCHJ/ioPL57uZ+Ub5WjLWceNW4UtSPyfPpDnkN
f8LsR/5HgAah1/dsgYOQN+ziGsiQCbkfreEoqsWze81aK3vi/Esz7Gb9Kn3wHDkZ
tA5iQ7G1GmmxiYyrz5Wij1uBvncBbLViGdPPsIP/B8Zmrgr/u2JjzBWkDzcw07jX
MH84fWqYNa+ueSbdPu6KFhJVfx+fH4X4hxX+d3Sc2m29oPzHPtA3+yiFqY8nxmw=
=ZKyh
-----END PGP SIGNATURE-----

--nextPart7896866.9i7YIXmRqC--


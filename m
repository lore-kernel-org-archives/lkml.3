Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3ISL1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:27:01 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:47379 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3ISL07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:26:59 -0400
Date: Thu, 19 Sep 2013 13:25:46 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Milo Kim <milo.kim@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 4/4] Documentation: add LP3943 DT bindings and document
Message-ID: <20130919112545.GC10852@ulmo>
References: <1378949700-6384-1-git-send-email-milo.kim@ti.com>
 <20130912152455.GN11227@lee--X1>
 <20130915112755.GB9765@ulmo>
 <20130916073000.GA3999@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline
In-Reply-To: <20130916073000.GA3999@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 16, 2013 at 08:30:00AM +0100, Lee Jones wrote:
> On Sun, 15 Sep 2013, Thierry Reding wrote:
>=20
> > On Thu, Sep 12, 2013 at 04:24:55PM +0100, Lee Jones wrote:
> > > On Thu, 12 Sep 2013, Milo Kim wrote:
> > [...]
> > > > diff --git a/Documentation/lp3943.txt b/Documentation/lp3943.txt
> > > > new file mode 100644
> > > > index 0000000..576ebd0
> > > > --- /dev/null
> > > > +++ b/Documentation/lp3943.txt
> > [...]
> > > If this stuff is really important (and most of it really isn't), then
> > > put it either in the commit log or in the driver.
> >=20
> > I can only speak for myself, but the initial driver commit message is
> > about the last place I look for this kind of information. I'd expect it
> > to be either somewhere in Documentation/ or in one of the source files.
> > In this case I'd probably look at the MFD core driver source file. More
> > likely, even, I'd just go google "LP3943" and grab a public datasheet
> > from TI where all of this can hopefully be found.
>=20
> The latter option is the most common. If the datasheet is publicly
> available, then there is no rhyme nor reason to put it in the kernel
> source too. /Documentation is already overloaded, it would be even
> more so if each and every driver residing in the kernel decided to
> bulk it up further.

Okay. So in this case perhaps Milo should simply drop the documentation
file. Perhaps link to the public datasheet from on of the source files,
although that could be problematic if the URL isn't permanent.

Thierry

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOt85AAoJEN0jrNd/PrOhjscP/2SXdcZcZU0onMPETW8arnDl
R/0HkhqIz1jDnDXD6SPT3kDb7gfAJdgAmMApeKxePvPBrf5co82DWcR1imufJ5wX
/Sm2pMXxRpcNATqsR1PF67wf7EZLIJnme5St3gVli4TJ53zPe0LnVnyGD6LXcigL
1vDHx9QMvg2nK0CI8D5ne1lz/mZKWNPhhigzFfwqscfc2h/blZUjk5bdl7N5bFHP
YDfNSF1ItyLWOgoqCj8Yt0ek6hzhcN38DLPXWkW0nkHVwjlAHvK2gT95aho1Gm0C
7zEjsE4HIr+bwn5NHhP2LNkn5haW874HOrvKNZseWiFCVh8dZR2TGrHxjq1jxRJJ
1yDrrCQ8aj8GSUGIm+u8WAXd0DqVqme9sblx20ganXRm4yOaorMweo4vsNqSOecU
iHQqSpZJ5OsaMdmGthUHI4E73Tpy0C/VW26JyR61ISxVjjDcdCOSVTjLFhPsy62e
uOEk3SK12VFv1k2SlWkLA9Gvql9tt7W0t1cmJqQTvPnPrdxvcfGie0rTrEA1jon0
xWqUklXuqRQ+cL1XRsyxyFQxyC+O+bIXEHzrQDASkrP7Lcuxj31S0gFbaAfEQ5K1
/etjrPUuFr9s4C25/wjxVIYMKVwNYiDzvZw4mRDiQC6HDdm27z9SqtkbSEnmmuC8
HDZuKg/Ja7sR50GqBtLj
=Hpmj
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--

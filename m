Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab3CXWO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 18:14:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44210 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754812Ab3CXWOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 18:14:55 -0400
Date: Sun, 24 Mar 2013 22:14:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
Message-ID: <20130324221444.GD18316@opensource.wolfsonmicro.com>
References: <201302170046.26569@pali>
 <201303241550.42801@pali>
 <20130324212149.GC18316@opensource.wolfsonmicro.com>
 <201303242227.32528@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VV4b6MQE+OnNyhkM"
Content-Disposition: inline
In-Reply-To: <201303242227.32528@pali>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VV4b6MQE+OnNyhkM
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 24, 2013 at 10:27:32PM +0100, Pali Roh=E1r wrote:
> On Sunday 24 March 2013 22:21:49 Mark Brown wrote:

> > You need to look at the schematics rather than the code here -
> > the code just needs to say what regulator supplies Vdd on the
> > device.

> This is problem, there is no info about regulator supplies for=20
> this device...

Well, you should seek support from the board vendor then.  Or try
things like continuity tests (the regulator will have external
components, most likely there's at least a decoupling cap you can probe
at the device end too).

--VV4b6MQE+OnNyhkM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRT3pIAAoJELSic+t+oim91iYP/2zDzpTyh9gSRadPQGGRnJv/
MACflEoyer5iy4qrNqcdlXyzr0fQlm3eorEaXODXUqunzz95YAavw4JQvxUQPT60
fOJEnjV3zcbS3AIaFdgUjhIFWE4P5RuBW9x+Z5oysiHE3gquPrNv1ag9DpdzFtxu
wi6eEVW6YU05Pnoi5+Lw1ZONipBSpexolmk2y/vJMnDodUEzYu7S1nyHayAjZ9kU
Y9BIfCVSbGA+chI8RJvE8bfOIfCNyun2QN73F7pDTKQHzLJM4CJkBEq/uzXOsQ0T
0YEA/VQIzP/VCMX01XYX+gcOgyuxFHAnajsdDqxxvvLKTpNWyo/qwlnkJAEKFn7K
kr5RpzvjATQkDqtZxiVb2vc56ggLbIrssgKnyhAc/zFAm1bXiEuoj3PvUcJsL+CZ
GT+hkYec2KQJ/DeFGuzDzVeQfGvzShl43zSupx36kvLNPnZVjhR40F3msgad8Q9p
h/05TkA9ArpB4M+Txda4KcirkaFmHb56mdH9oSNxcLJ774+t2rBarJB9vaU0Camh
oj54Tu8usuA75eCjtKujFY9Rlv1vpzC6G36xv1KRVVd5DRtYQbx1QajLr3qAYn63
7UgywKHrb3pEGLnXI8oL+EuxzBPL/sEQWeRBG4V+YZ/bIyxeZr6NxxhpuEtwgZjg
zjpgfgLYb0CAuV3akkJd
=9KmJ
-----END PGP SIGNATURE-----

--VV4b6MQE+OnNyhkM--

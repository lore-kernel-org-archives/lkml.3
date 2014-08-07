Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbaHGOLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:11:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:23552 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417AbaHGOLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:11:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,818,1400050800"; 
   d="asc'?scan'208";a="584771781"
Date: Thu, 7 Aug 2014 19:30:01 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Sugar <shuge@allwinnertech.com>
Subject: Re: linux-next: Tree for Aug 6 (sun6i-dma.c)
Message-ID: <20140807140000.GH8181@intel.com>
References: <20140806172857.44a2a900@canb.auug.org.au>
 <53E25AFF.6030409@infradead.org>
 <53E262BF.7040509@infradead.org>
 <1407398174.3373.1.camel@paszta.hi.pengutronix.de>
 <20140807112507.GB15297@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rnP2AJ7yb1j09OW/"
Content-Disposition: inline
In-Reply-To: <20140807112507.GB15297@lukather>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rnP2AJ7yb1j09OW/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 01:25:07PM +0200, Maxime Ripard wrote:
> On Thu, Aug 07, 2014 at 09:56:14AM +0200, Philipp Zabel wrote:
> > Am Mittwoch, den 06.08.2014, 10:15 -0700 schrieb Randy Dunlap:
> > > On 08/06/14 09:42, Randy Dunlap wrote:
> > > > On 08/06/14 00:28, Stephen Rothwell wrote:
> > > >> Hi all,
> > > >>
> > > >> Please do not add code intended for v3.18 until after v3.17-rc1 is
> > > >> released.
> > > >>
> > > >> Changes since 20140805:
> > > >>
> > > >=20
> > > > on x86_64:
> > > > when CONFIG_RESET_CONTROLLER is not enabled:
> > > >=20
> > > > ../drivers/dma/sun6i-dma.c: In function 'sun6i_dma_probe':
> > > > ../drivers/dma/sun6i-dma.c:911:2: error: implicit declaration of fu=
nction 'devm_reset_control_get' [-Werror=3Dimplicit-function-declaration]
> > > >=20
> > > > Add a stub for that function?
> >=20
> > There is no stub for this function by choice.
> > Drivers that can accept stubbed out CONFIG_RESET_CONTROLLER functions
> > should use devm_reset_control_get_optional instead.
> >=20
> > > or that driver's Kconfig entry could select RESET_CONTROLLER.
> >=20
> > Yes, please.
>=20
> A depends on would be better I guess.
Patch pls :)

--=20
~Vinod


--rnP2AJ7yb1j09OW/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJT44ZgAAoJEHwUBw8lI4NHo6UQANODEGFpKh26b0JmNl1NFHzp
AXhDQpLZX7mvBBh9I6GoUZ3VxrvJMl9Syu6Bk2gKVw+FI504YZTQ/uxVCBygBlpK
pslPfAAmFi1/Y9uyvcgvqJovdkImcF6JKAv/H6kxiaE67DmyNO5n2/nc+iMSuWrS
4EV9IU5Zdi98FcVhA0DbLUKHmqBLbzxxI24xr/K2kfHnLiiIvy1FpI554pM3ZEXA
c9DrBFJOi3+yR7afUXGDH2pcXSvkjmuJfCUOx/gk/6R3QWStetLaKspQs6XJMWEa
aLN95oL9OuF1HOffKVlchoygvtmHWN4fq4je1Dwt8bVI+R0Ugj+cEi+yaLZ7Xi/P
NmydBY4aT60gIr1Zj3bcz0uwhgObmrItG++jZqwi/AlHXSIohHqfthwE+MkEYwpX
dq5/cjFtxhha2+0R1VL0gY6dU/5RhB1Hzlg0vfkGWl027l/j2NqxT9CQ3BCkBxtC
dgK2Hf9JBbuT2wYM7BKPc921d1Yyb5JEodKepWzDgqu9i2eB/4SmCd6As+dufnx1
0vkuczeyqCTd4kiTSrre8DDznWG6qVyqflADe0BCzWCf08gplbKy/7VgU9RSeEBc
hUYH4WUoQq6rkkmcCwSil97MAM9cJpWCi8e0ZQcNqlx7I11OZe2zl/ADlayCyEHP
r2j/IPNMfulG2x9h7pAX
=HcEO
-----END PGP SIGNATURE-----

--rnP2AJ7yb1j09OW/--

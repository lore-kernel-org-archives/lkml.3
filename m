Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3CLSkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:40:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49699 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755274Ab3CLSkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:40:36 -0400
Date: Tue, 12 Mar 2013 18:40:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Afzal Mohammed <afzal.mohd.ma@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: Question about fixed-clock
Message-ID: <20130312184033.GK19942@opensource.wolfsonmicro.com>
References: <20130307184240.GA3327@afzal-ThinkPad-R50e>
 <5139155F.5050407@gmail.com>
 <20130308021527.GA28481@opensource.wolfsonmicro.com>
 <5139E7F3.5010906@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9RxwyT9MtfFuvYYZ"
Content-Disposition: inline
In-Reply-To: <5139E7F3.5010906@gmail.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9RxwyT9MtfFuvYYZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 08, 2013 at 02:30:27PM +0100, Daniel Mack wrote:
> On 08.03.2013 03:15, Mark Brown wrote:

> > Wouldn't this just be set up by the DT in the same way that other
> > off-SoC hardware is?

> Well,  I thought so too. To repeat, in my DT, I have:

OK, I got CCed in part way through the thread.

> I would have expected that "fixed-clock" is matched by a driver lurking
> around for DT boards, just like what the "fixed-regulator" driver does
> for instance. But the clock device isn't initialized unless board code
> explicitly calls of_clk_init() with a table mentioning "fixed-clock", as
> in my patch.

> I don't know the clock framework well enough, but it seems that either
> all DT boards are supposed to do the same in their generic bits (which
> sounds like a lot of code duplication), or the fixed-clock driver should
> behave like any other driver wrt its probing from DT. I'm open to
> suggestions :)

Your expectation sounds like what I'd expect too...

--9RxwyT9MtfFuvYYZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP3aYAAoJELSic+t+oim9xwAQAIDeuL+USfv5RSHZJ4Od7DbA
7OjClHeRSIl+vM2IW6dynd6JsyYURRMTrTPzBKBwh0vieP1ixE+wUH0MWiJvCtph
uqJMtiDjrkOgzeSTfIaQVDabXE7dvQZtt3yUig/DpzUa8+gW4+RD+5iuAr9AQMVA
VrAX7N1Ii8HDz5h8RB5QF09xNNArjW9/KJEc9+4Plm5LSCFN4xbPpHJ0I5dEjDal
XmwXkV1RGxvl8L0LeKjeNNDg+CeUeA/dHO2hRpQkwggBrRNsmbcbbeAwJe4f1997
k6vvwhcNT1SQj52kOyojy4cZ1KPG1W/O00QRKxi/rEVmX+zGbUUdgs+FRXmj00TV
LQ/ubl1tNJIECFY6x4sw8G/2nrtHp1E5qGG/Kegb1hOstSALf4jyl3xcRFv7a7b3
46vrh9QlWgOTo4nIF44IGS4pSKwfEqDofULNA0vXBzyW2xe66ntqex+XJ9qeV0+y
3JzEeDCbjLeJp2LknixG7dJ1VHPRjZZj9TPGpTXZFMiaBleG4XADPVcg5Dey+pCW
OVwJ4OyxHaAha6LWn2vlT3kOnD5pVzkR8zBTgXxtJlHoN+VGLqvCqMjSKBnK70GO
6pde4qvApgmwMqFxHp7F2IPZtCDxWuNVW9eAKu92A3rliNbJlw0xGR0OiUF4s5NC
/9nx/ftDKv3VNkOG5m5V
=wEMw
-----END PGP SIGNATURE-----

--9RxwyT9MtfFuvYYZ--

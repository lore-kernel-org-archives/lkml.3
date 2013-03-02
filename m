Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab3CBWdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 17:33:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50278 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058Ab3CBWdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 17:33:42 -0500
Message-ID: <1362263610.3768.148.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Put git commit 51ac8893a7a51b196501164e645583bf78138699 on the
 stable tree please
From: Ben Hutchings <ben@decadent.org.uk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Greg KH <greg@kroah.com>, Jan Beulich <JBeulich@suse.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 02 Mar 2013 22:33:30 +0000
In-Reply-To: <20130225164654.GA10672@phenom.dumpdata.com>
References: <5127AED302000078000C0779@nat28.tlf.novell.com>
	 <20130222165704.GA21811@phenom.dumpdata.com>
	 <20130222170742.GA5126@kroah.com>
	 <20130225164654.GA10672@phenom.dumpdata.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/pfL51GJaEZcP6cR59Tg"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/pfL51GJaEZcP6cR59Tg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-02-25 at 11:46 -0500, Konrad Rzeszutek Wilk wrote:
> On Fri, Feb 22, 2013 at 09:07:42AM -0800, Greg KH wrote:
> > On Fri, Feb 22, 2013 at 11:57:04AM -0500, Konrad Rzeszutek Wilk wrote:
> > > On Fri, Feb 22, 2013 at 08:19:30AM -0800, Greg KH wrote:
> > > > On Fri, Feb 22, 2013 at 10:46:45AM -0500, Konrad Rzeszutek Wilk wro=
te:
> > > > > Hey Greg,
> > > > >=20
> > > > > Please put git commit 51ac8893a7a51b196501164e645583bf78138699
> > > > > commit 51ac8893a7a51b196501164e645583bf78138699
> > > > > Author: Jan Beulich <jbeulich@suse.com>
> > > > > Date:   Wed Feb 6 10:30:38 2013 -0500
> > > > >=20
> > > > >     xen-pciback: rate limit error messages from xen_pcibk_enable_=
msi{,x}()
> > > > >=20
> > > > > on the stable tree please. It is an security errata fix and shoul=
d
> > > > > have had the CC: stable@vger.kernel.org but did not.
> > > >=20
> > > > Thanks, what stable kernel releases should it be queued up for?
> > >=20
> > > 3.4 and later please.
> >=20
> > On Fri, Feb 22, 2013 at 04:45:55PM +0000, Jan Beulich wrote:
> > > Anyone from 3.1 onwards that is still being maintained.
> >=20
> > Hm, who should I believe here...  :)
>=20
> Just in case my previous email crossed paths or got deleted.
> >=20
> > It doesn't matter for me, but for the 3.2 tree, it does.
>=20
> 3.1 and later please.

Queued up for 3.2.

I had to add '#include <linux/ratelimit.h>' in
drivers/xen/xen-pciback/xen-pciback.c, as printk_ratelimited() uses
DEFINE_RATELIMIT_STATE() which is defined in <linux/ratelimit.h>.  (In
mainline this is inclued in <linux/device.h>, but really it ought to be
included in <linux/kernel.h> as well.)

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-/pfL51GJaEZcP6cR59Tg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTJ+Oue/yOyVhhEJAQqwuhAAqxj+ADkjDEZbTPCLoL7TMib9UnJisY32
f8a91/STZhGH2SnyzcngEnpIm9rVZ/x8D5hhwtjzoLt3R78Jej2qB70C1ip5x5tV
l0q1sVDLDV3DnC4TxQ/O7yTqkIaBmKPvywq308bWT1+eU+A8vvjB/7T6c0rEl1Gw
Wh7Z1dBNCVWXZTUo7JNeD6jDMdU8XSqh0UD8DJAS2SbMNYUI0zGr2fOCeEXB4D8Z
bGvdhLElMRbEPZpNurTq1V2Snuac5lzqjOFhWiIzqBUq4b/shTDj6zUJ6TH7qnfd
tMP280/D5PSxoS8AVUYyRfTvgqdOMdpYE934JYcj52b9WCpEgfDKr0t0NjeDXgUM
avhsyhFaKRSCFxoiFC4kS4058frAKf27oJkCVIg8tCnPYO9CMD33A+nx8xBbcL23
1+/WCD/moLdT8GdXmg2PJCGK9gfm4+Qp/poVHikFuuWzHVqLIU/bpXV4NfNZPJbu
ldnlwooFHnUGmpegdF9cRGKHgdDZD+TVK3GMkKqNuqKNMgocfJYwvwb/lPEff1NW
/s5PB8ihAG6SuB1GtNz/x6k8umaNeleJE93Zp3fZHDWpRb2hB9+bRHHedB2m4E49
MIE3/h9UREwzcBZXf5YNtGGrrGVVR0TuFiWcUkWrpufDZkjueJz4mKUC6zqSwvAP
s/0YXBPxjUY=
=taf2
-----END PGP SIGNATURE-----

--=-/pfL51GJaEZcP6cR59Tg--

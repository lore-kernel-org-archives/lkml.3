Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbaDXP0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:26:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49173 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaDXP0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:26:12 -0400
Date: Thu, 24 Apr 2014 10:26:01 -0500
From: Felipe Balbi <balbi@ti.com>
To: Balaji T K <balajitk@ti.com>
CC: <balbi@ti.com>, <chris@printf.net>, <ulf.hansson@linaro.org>,
        <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] mmc: host: omap_hsmmc: a few improvements
Message-ID: <20140424152601.GR26661@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395878690-9650-1-git-send-email-balbi@ti.com>
 <20140421173203.GH22794@saruman.home>
 <53568B04.4050703@ti.com>
 <20140422154858.GN5524@saruman.home>
 <53592BF5.6020104@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N+qDRRsDvMgizTft"
Content-Disposition: inline
In-Reply-To: <53592BF5.6020104@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--N+qDRRsDvMgizTft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 08:51:25PM +0530, Balaji T K wrote:
> On Tuesday 22 April 2014 09:18 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Tue, Apr 22, 2014 at 09:00:12PM +0530, Balaji T K wrote:
> >>On Monday 21 April 2014 11:02 PM, Felipe Balbi wrote:
> >>>Hi,
> >>>
> >>>On Wed, Mar 26, 2014 at 07:04:45PM -0500, Felipe Balbi wrote:
> >>>>this series lets us access the newer registers introduced
> >>>>back in OMAP4 which give us some valid information about
> >>>>the OMAP HSMMC IP like max block size, support for ADMA,
> >>>>support for Retention.
> >>>>
> >>>>Right now, only setting max_blk_size correctly as supporting
> >>>>ADMA and Retention will take a lot of work.
> >>>>
> >>>>Tested on OMAP5 uEVM.
> >>>>
> >>>>Felipe Balbi (5):
> >>>>   mmc: host: omap_hsmmc: pass host as an argument
> >>>>   mmc: host: omap_hsmmc: add reg_offset field
> >>>>   mmc: host: omap_hsmmc: introduce new accessor functions
> >>>>   mmc: host: omap_hsmmc: switch over to new accessors
> >>>>   mmc: host: omap_hsmmc: set max_blk_size correctly
> >>
> >>Got mislead by your reply to this series, about the alternative way of
> >>reading memory size from CAPA register
> >
> >sure, we can do that if you prefer, I just felt I wouldn't touch
> > platforms I can't really test :-s
>=20
> I think so, since those 3 newer registers are not documented for all plat=
forms.
> Not sure whether it is valid in those cases where it is not documented.
>=20
> Since capa register has these info and can be applied uniformly across
> all paltforms, I feel reading capa register is the way to go. Do you
> still think there is a need for new api with no offset ?

that same HWINFO register gives you information about availability of
ADMA or not.

> >>>this has been here for almost a month, any comments ?
> >>>
> >>
> >>Do you see any performance impact with this series ?
> >
> >in the normal case ? no... it helps only with large transfers
> >
>=20
> Do you have the numbers ?
> Is it for read or write,
> how large should the transfer size be ?

no numbers available... didn't save anything.

> I couldn't get any performance improvements with this patch series,
> Could you please share your test setup, may be I am missing something.

just OMAP5 uEVM with UHS-I memory card.

--=20
balbi

--N+qDRRsDvMgizTft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWS0JAAoJEIaOsuA1yqREvAAP/RIwXEg2eu1Zyokzylq5Fm6w
f4S2M8wpKaoKKvi8QalZ31szXnLDC2jyEaHBmc7X0BPS2AZysnI8a/2dwOJ6QDDR
Ftz+AtZJYQ5vSt5HYMvLgzzmQcIoAw7bEoKMqlrHEZFWEmyVCB7YCT1w2eYKrNWJ
O5GAXJ6oZ11zw9byWEsa/W/NxhlqvJEW/tJZZIs0899/1MYxvYYBK/wnTwnQ7RsU
UEob3vCNZdhoNFjYi4lTgrMVB8pH78W100Oii69a+lvNn/KkRrE2b6k7EvPdzirK
U59Oq/GA1izde4hTH916Ai0BlVR9hTXg9W347QtvkYXSjkQHDN7+mWFs3BT9CTGd
OsvrE8qlRw93lRf8UgzRL495nfrR1hwSDqP1JRqY6UHT8eC41UnKmHcIcUc8k8L7
Yw6oXqE52I8QqhwD5Q7+D/qwBATwZxzotfzqqhjMiwvf8uPdXlnW5wk2AcsIKGvG
/m6lM7kPLuGbhG6qHw9pxxxf5yEdjZ+lBwOycF1PHhXvKMR38/l63iEH85GyBVRL
WP/0O3VlqKFI1fjZ+yfS2D1s4AkwGsfGm4fqJruPgSpPHqmNVzuXSxTLk71Ae5z/
1mgV42M3lSO1hsJp0mvMQ3HFrKmO1RBO8qxlqyPGc+TQMuWxv6eG0bGPc05N3ktI
dqy7NylSantxN9kwN1ZJ
=dUdu
-----END PGP SIGNATURE-----

--N+qDRRsDvMgizTft--

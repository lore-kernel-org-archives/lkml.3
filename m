Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaKYOpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:45:40 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58659 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaKYOpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:45:38 -0500
Date: Tue, 25 Nov 2014 08:45:44 -0600
From: Felipe Balbi <balbi@ti.com>
To: Peter Chen <Peter.Chen@freescale.com>
CC: Kiran Raparthy <kiran.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Benoit Goby <benoit@android.com>, Todd Poynor <toddpoynor@google.com>
Subject: Re: [PATCH v3 3/3] usb: phy: hold wakeupsource when USB is
 enumerated in peripheral mode
Message-ID: <20141125144544.GC6360@saruman>
Reply-To: <balbi@ti.com>
References: <1416849900-29959-1-git-send-email-kiran.kumar@linaro.org>
 <1416849900-29959-3-git-send-email-kiran.kumar@linaro.org>
 <15cad5ef7627483cbba96e05fe180813@BN1PR0301MB0772.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0lnxQi9hkpPO77W3"
Content-Disposition: inline
In-Reply-To: <15cad5ef7627483cbba96e05fe180813@BN1PR0301MB0772.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0lnxQi9hkpPO77W3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2014 at 07:06:18AM +0000, Peter Chen wrote:
> =20
> >=20
> > usb: phy: hold wakeupsource when USB is enumerated in peripheral mode
> >=20
> > Some systems require a mechanism to prevent system to enter into suspend
> > state when USB is connected and enumerated in peripheral mode.
> >=20
> > This patch provides an interface to hold a wakeupsource to prevent susp=
end.
> > PHY drivers can use this interface when USB is connected and enumerated=
 in
> > peripheral mode.
> >=20
> > A timed wakeupsource is temporarily held on USB disconnect events, to a=
llow
> > the rest of the system to react to the USB disconnection (dropping host
> > sessions, updating charger status, etc.) prior to re-allowing suspend.
> >=20
>=20
> Hi Kiran & Felipe,
>=20
> Just two questions for this series
>=20
> - Will it be the default behavior for all peripheral drivers?
> - If the peripheral driver's PHY driver does not vbus event, how to
> support it?
> For example, chipidea udc driver has its vbus interface at its
> controller register.

hmm, good point. Since it's so late, I'll just go ahead and drop
$subject from v3.20. Let's delay only $subject to v3.20 merge window so
we have some more time to discuss these details.

cheers

--=20
balbi

--0lnxQi9hkpPO77W3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUdJYYAAoJEIaOsuA1yqREF20P/1vg6MZ67qz+Tn64k5Gu9ZD3
nAzhKRd5i1+HOIZAgJR8VwswBOizQeki42gEUnqei+mQc2VXWc80cKpjy+mkcVJa
zJnRFU4KcOnqC5WrwHWc3IbcdbhmdRf28Bc6V6+1X9RdN26eg7DHbA4pFn4bB254
6u23mdMvBGnuJ6eHOwfODqOJMpucqYIuI5eMxE9tNKhRwEKtSQwHxBxSZczAw7ow
G6YooZtoA/SQXtHY4S2ZpxtA3vYYGAOmzixTudb6fJ7AL5GpvlTIUpRhNMumnXHp
z5ogdUkQ5weK3XKMTGypeE/KfGf9vYwzcFbHImOtjrUEDTT2D8WIFEgXH8s8SgG/
jRiopCh9sx5VLHpW8EMen1QCf4A4ZIjj1qR0ZMakPv1cN6rlN+4VfzJIX3isF95k
TkIxwDrZuR5vQt2jGyc/LK5r3Y2X+o9OstvhJEpMUT08TRWuN/lqbesSkXvRyTz7
te9y4AKfbat9ZtyGN/xloE1mIv6SKChvznnObEZmT3ooov/0CZvXQk8WdI2/yt6m
Q8OSxtBxOFLbB4teFVV7OlZT4bSntwdcnEMeH4xIK/2x0+OCVt57YaBwlzLjtn3q
lewtHBXlTZPqsnLydp2CnsMKU1QhTcYnEqzvytKJ5CDv9ph4W3uosrA87yCfIyXN
yggmbJoFy+Y/ckmailaI
=SPV5
-----END PGP SIGNATURE-----

--0lnxQi9hkpPO77W3--

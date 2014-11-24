Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbaKXUpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:45:52 -0500
Received: from foo.stuge.se ([212.116.89.98]:41895 "EHLO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaKXUpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:45:51 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2014 15:45:51 EST
Message-ID: <20141124203908.4425.qmail@stuge.se>
Date: Mon, 24 Nov 2014 21:39:08 +0100
From: Peter Stuge <peter@stuge.se>
To: Felipe Balbi <balbi@ti.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        George Cherian <george.cherian@ti.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: musb: core: Disable the Interrupts till BABBLE is
	fully handled
Mail-Followup-To: Felipe Balbi <balbi@ti.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	George Cherian <george.cherian@ti.com>, gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1415953486-6000-1-git-send-email-george.cherian@ti.com> <20141118211734.GA19146@saruman> <54736FBE.6060505@linutronix.de> <20141124182053.GD25712@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eDB11BtaWSyaBkpc"
Content-Disposition: inline
In-Reply-To: <20141124182053.GD25712@saruman>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eDB11BtaWSyaBkpc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Felipe Balbi wrote:
> > > A babble only occurs when
> > > the device side tries to move data without the host asking for anythi=
ng.
> >=20
> > It also occurs if the device moves more than packet_size bytes. Not
> > really helping, I know=E2=80=A6
>=20
> hmm, why would the device move more than wMaxPacketSize at a time ?

Some devices are buggy.


> That's certainly babble :-)

Certainly! But musb shouldn't fall over or lock up because of it, should it?


//Peter

--eDB11BtaWSyaBkpc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFUc5dshR3Q0dhIfEgRAq8mAKDbN63JeM2JpW7R3dLLu2Yp2soBTwCcDrmA
ip8VzyIyswotk4MfVqm3S8w=
=Hpu/
-----END PGP SIGNATURE-----

--eDB11BtaWSyaBkpc--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaIXXOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 19:14:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51677 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaIXXOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 19:14:19 -0400
Date: Wed, 24 Sep 2014 18:14:11 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michal Sojka <sojka@merica.cz>
CC: <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Bryan Wu <cooloney@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.vokac@comap.cz>
Subject: Re: [PATCH v6 2/4] usb: gadget: Refactor request completion
Message-ID: <20140924231411.GA27672@saruman>
Reply-To: <balbi@ti.com>
References: <Pine.LNX.4.44L0.1409241106100.1580-100000@iolanthe.rowland.org>
 <1411591401-5874-1-git-send-email-sojka@merica.cz>
 <1411591401-5874-3-git-send-email-sojka@merica.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <1411591401-5874-3-git-send-email-sojka@merica.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2014 at 10:43:19PM +0200, Michal Sojka wrote:
> Use the recently introduced usb_gadget_giveback_request() in favor of
> direct invocation of the completion routine.
>=20
> All places in drivers/usb/ matching "[-.]complete(" were replaced with a
> call to usb_gadget_giveback_request(). This was compile-tested with all
> ARM drivers enabled and runtime-tested for musb.
>=20
> Signed-off-by: Michal Sojka <sojka@merica.cz>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUI1BDAAoJEIaOsuA1yqRE9vQP/0UMvQ3mOl301Avr6aaT9lnd
UcoTVmLATYUxDfVRfF+qgs0gBhS5Bc1GgcY/GoF0oBHb0gTBC8FrnYBXHMdAmPvf
42Eumjx4SVkOViBXVN7O7Vj66p72Iv0OmNE+wC+yCHiZp+LRgtXcL3+arhg4FB3B
TTepHdc0SmNCtNpG3zWvSNfS5FLC8IE9XY3MPsZx+w123qx/V3L58F4pWLybRdUQ
yGk0wbTIvWi9bFBUWAIY7UEemiNLep4N6O3pspA+ulExYgUindJPJgQsJeTJOQ+0
DjQUkTiggu0lLEW5D5DWilUaHJDOX+UbM5bISLhEIwbZmCdU7zemg6l9qQkLsXTZ
auWJtvSiwTcMk44eYCC0ZWq6CiQ0df1Hvj8vBhYbXjsJOt0NnoLt3brYqF8vSCMH
cEyEPj4EY+PGRYLZUfIRJaxuJaf6TnJuA130UGNXhscklHkRZ/vP3FJb4dBTLRYR
BXHgMa3uA2sUL2FHd/3Nfqpn8pMHF9tcE/nxwg8M1qRloRrilREFCzCARAKgk8sV
XTgf+uYjRZSzz1PsouxXPpK32RWZbInSWILXrTaO9gbqhfBdfX1B3S8YnZ7ZGzRa
2p/B3npgFbK5bJG3KTe+uZ4J2PPMq/oN4yjN39tRy0iHQmlE/wY3Hx8CtOTMFByo
ZoXAZROI8/qIurncUw72
=Aafc
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbaKUP4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:56:36 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:34688 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758442AbaKUP4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:56:34 -0500
Date: Fri, 21 Nov 2014 09:56:41 -0600
From: Felipe Balbi <balbi@ti.com>
To: Krzysztof Opasiak <k.opasiak@samsung.com>
CC: <balbi@ti.com>, "'Robert Baldyga'" <r.baldyga@samsung.com>,
        "'David Cohen'" <david.a.cohen@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <andrzej.p@samsung.com>, <m.szyprowski@samsung.com>
Subject: Re: [PATCH v4] usb: gadget: f_fs: add "no_disconnect" mode
Message-ID: <20141121155641.GK7508@saruman>
Reply-To: <balbi@ti.com>
References: <1412860911-23985-1-git-send-email-r.baldyga@samsung.com>
 <20141103161102.GM27425@saruman>
 <20141105194321.GS6548@saruman>
 <20141113024414.GA19072@saruman>
 <0b1401cfff5e$d86dd8c0$89498a40$%opasiak@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7Ke/meiCZutM6I/"
Content-Disposition: inline
In-Reply-To: <0b1401cfff5e$d86dd8c0$89498a40$%opasiak@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--C7Ke/meiCZutM6I/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2014 at 05:28:22PM +0100, Krzysztof Opasiak wrote:
> Hello,
>=20
> > -----Original Message-----
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Thursday, November 13, 2014 3:44 AM
> > To: Felipe Balbi
> > Cc: Robert Baldyga; David Cohen; gregkh@linuxfoundation.org; linux-
> > usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> > mina86@mina86.com; andrzej.p@samsung.com; m.szyprowski@samsung.com;
> > k.opasiak@samsung.com
> > Subject: Re: [PATCH v4] usb: gadget: f_fs: add "no_disconnect" mode
>=20
> (...)
>=20
> > > > David, you have been messing with ffs lately, can I get a
> > Tested-by
> > > > from you on this patch ?
> > >
> > > ping. David ? Any chance you can test this one out ?
> >=20
> > a reminder on this request, it's getting close to tree lockdown
> > (probably another 2 to 3 weeks).
>=20
> I have tested this patch today but I'm afraid that I can't give
> tested-by tag:
>=20
> When I kill the daemon and then reconnect my device I get on my host:
>=20
> [776092.877175] usb 1-1.1: can't set config #1, error -32
>=20
> While on device there is only:
>=20
> [ 2147.035340] configfs-gadget gadget: high-speed config #1: The only
> one
>=20
> Moreover, I'm not very enthusiastic about the convention in which we
> allow
> to reconnect the device without any changes.
>=20
> In my opinion when daemon has been killed we should allow user to finish
> communication with other functions and then simply unbind our gadget.
> This should happen not only on reconnection but also when host is trying
> to enable configuration which contains this function "zombie".
> This function is not fully operational so it is very good idea to
> allow user to finish his job with other functions but when he reconnects
> the
> device we should unbind gadget to notify userspace that something is
> wrong.
> The same when we switch configuration.
>=20
> What do you think about this Michal and Felipe?

let's wait another merge window to discuss this one better. If it's
causing confusion/regressions, we better delay it.

--=20
balbi

--C7Ke/meiCZutM6I/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUb2C5AAoJEIaOsuA1yqRELN8P/AnoUtz2EKNwtbu3ep+gOg9b
uUZ98aOsQOmBznqfsGrso7L12kXJiZveustHzuuPlLoPglRZgEtlCO1lyvmZuYQJ
M7KFVkmR3X0a3mxkQuqUhE8zEQn61t52atjaw2R4KQH+9IP8mms7n8OFWDNcKM4L
QLVyoEk3pfanhTXNGE5MY0EK6eoYjToh8bxD5gxOTZT6jNsybZOH7ufOWdInkIMw
IHXKefdY8xmszEo170Dx4kqhvdpIwVEMFX5+wrIoOxNGlDvmOroGjiueu46s+p91
3C2J0ekbgutF+6Idd/z+mljESg4sUU/NAfWaq7moYr6xApO/8//CmFN3B1EaSXOu
GJQNsFsPgYh41jvA0vJjGLhe1TOT9821932YB8qYk9k/T+FUJAVupQbANkUfuAEM
gn4GMkmeBIzYgfe3nufAnKDiUAkyYubaX6Jq7s66QAVXicAh4DhSDDeKnn+psXgI
oC/ZqdO8vwCxNzH8vhv7WQAY7NUg04CpXLb3YfUr9Xqzwpo1FeT1gRaGYonIQFRn
W8sK64hAxEeMCpEc8iXBk9kd9Q+UFntv5JNESmcmBP5JYmpcDyjIsNXDg5ss99es
nb1dU+xq2ufjm2N1/Cs6SrU0EqGNC778Zaq1dB4A1NcWedNWyPcZWrJaWm6Z1nQr
2+2WSAtj17NxktPOWvv8
=UwqR
-----END PGP SIGNATURE-----

--C7Ke/meiCZutM6I/--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab3DBImt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:42:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60848 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760756Ab3DBIl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:41:58 -0400
Date: Tue, 2 Apr 2013 11:41:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Felipe Balbi <balbi@ti.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree with the  tree
Message-ID: <20130402084139.GK30286@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130402171143.ba5dc16d004310542d611b79@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opg8F0UgoHELSI+9"
Content-Disposition: inline
In-Reply-To: <20130402171143.ba5dc16d004310542d611b79@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--opg8F0UgoHELSI+9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 02, 2013 at 05:11:43PM +1100, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> Today's linux-next merge of the usb-gadget tree got a conflict in
> drivers/usb/chipidea/udc.c between commit adf0f735e61a ("usb: chipidea:
> move debug files creation/removal to the core") from the usb tree and
> commit dc9e2873b740 ("usb: chipidea: let udc-core manage gadget->dev")
> from the usb-gadget tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

looks alright to me, thank you.

--=20
balbi

--opg8F0UgoHELSI+9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWpnDAAoJEIaOsuA1yqREZE4P/iDX2KHjHKVmsxPV4VXDqllP
m/EuYX7UQOvR1W2FgzI94TN+ypgpVejLti4cXmxb39BC1ueb2U9DE2Q5fNWC2lJ8
d8f3g7oc995GY27yByGS8504j2hR38Kp1lDrXGZXRwv0Qlp17ljj4jT0MsInKMuD
XsOyqLI352A+Bs96qTxdVHDgQ1ebVnhaFWsDtJ8a6AAvY1GY1cwJmQr3VgFvXeU+
CxOS2Glf8VaefJBNZwTdtC9bdHvIcog9J4j6ro06xWwpSl0JUwl9UyuPbpmWmFoF
zbaQ/7HE7bWcnhUZR2I1R4HsyDSt3PD07BfP9H4PVu4lu4s1MSgakz+v3LRTGBpE
L9zWA3/nGLaAIZe/LmxZDE3DWHyfHvX2p2ixEVIwUyBKZnJJ99XWylSVitfTXt3j
UiNEUa/sSTaSpZQFj5sYR3okz8xHAWqMVSjxZQ322U1ZiLgSi5Uci/0Rdhok/k8r
eLNERbFGhQq5hinfrcEIhhQy86fvKsBEOXa51J4OCrB3KAPUwvmgP1IpbXlGJmAV
HcpDcg4f4tjs2bEgAgKf/u8Z43d21JldJeZDOwgQ3O2oOlD6PWEOn0nh49tQaxgh
4fUHba3I0oqTr3/Djn5KTr844Nr/jVQ1yigy8YZOwDAg13DaLe2JBTLV5bNHAff+
Fmqe8sNPnhWy6hNsWnM2
=IHHg
-----END PGP SIGNATURE-----

--opg8F0UgoHELSI+9--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaICUOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:14:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50472 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbaICUOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:14:39 -0400
Date: Wed, 3 Sep 2014 15:13:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Stefan Agner <stefan@agner.ch>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <jingchang.lu@freescale.com>, <peter.chen@freescale.com>,
        <s.hauer@pengutronix.de>, <kernel@pengutronix.de>,
        <shawn.guo@freescale.com>
Subject: Re: [PATCH RESEND v2 3/7] usb: phy: mxs: Add VF610 USB PHY support
Message-ID: <20140903201353.GI31855@saruman.home>
Reply-To: <balbi@ti.com>
References: <cover.1408391385.git.stefan@agner.ch>
 <acb7c055ded38c74291d0f0d8d2fdca54a8b95f8.1408391385.git.stefan@agner.ch>
 <147749d74a57dcf72ed9bd81249d0ca5@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CD/aTaZybdUisKIc"
Content-Disposition: inline
In-Reply-To: <147749d74a57dcf72ed9bd81249d0ca5@agner.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CD/aTaZybdUisKIc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 01, 2014 at 06:36:50PM +0530, Stefan Agner wrote:
> I think I still miss a Signed-Off-By Felipe Balbi here...
>=20
> All the rest should make it into 3.18, but USB without PHY is no fun to
> use ;-)

this is already in my testing/next

https://git.kernel.org/cgit/linux/kernel/git/balbi/usb.git/commit/?h=3Dtest=
ing/next&id=3Dd0ee68b59e6aa33221445dc555efac3736b89026

--=20
balbi

--CD/aTaZybdUisKIc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUB3aBAAoJEIaOsuA1yqREzWkP/AwxYnfuDIHeIElr6un7UEX6
Xf4UjoFkPe+IPlV3oXS1n7VsORXmbkp9EdJ3rpiZtd1TeJ1oK1hNk3ikxuupQlmm
94j6FtCgD3FDmD2vK32d2ppIC9DvxrYdRXBlzVFPMHaDW7PupmCS26BI/cdk1Dwi
D0PbkCvXGHnUnsPmE2gE9DRuItDn5yp6KfvMj/twBOYO7P6d6UFBlg1o+91wc4Wr
pw7ScgB7fGLMCCA0oMj0pG+gTadJc8/xo9kfnhtfiwk+VK+N3XCW5VL4sYJUU95t
zSbbBFOmuK6Vrf3QJ7K8mafe3A2KbpkCLDn69oR+W/V2cZuwDVKncgOoX8ypydPO
9xt3eDwgD1rTOhNwSM2xWwbJ6uMz4tGDSkn7e8+a9pBXSXHWaSm9SwoxoXqUfXL9
8amJuHwLhGgETB45IaMtxfmUjLl5dZzkxrOnSpajRZxgNzmsvMNcXulllJOkoH/J
h46Jb0fkow2k6vw1vuHTGbr98tHCJZqhg6kyi7lLGD5l/V9Y5VfJg2k9qqAEIMON
23maOwrZrlV5U6VcHRlJ4RzyHqB09eUxCKUYXbL9W4dpHqFocyMZBr5VXmKfzJLM
wcKElS8KJpc6MTfUejxoDTXAwSsU59jcSqtCEYkwHhmb//iWGGTWFly91EkmvW7P
IDewbtScxdQs1ef7so54
=CijQ
-----END PGP SIGNATURE-----

--CD/aTaZybdUisKIc--

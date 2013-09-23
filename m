Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab3IWTaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:30:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39378 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab3IWTah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:30:37 -0400
Date: Mon, 23 Sep 2013 14:30:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Behan Webster <behanw@converseincode.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] usb: gadget LLVMLinux: Removing the use of VLAIS from
 the gadget driver
Message-ID: <20130923193030.GM30811@radagast>
Reply-To: <balbi@ti.com>
References: <1375407344-30120-1-git-send-email-behanw@converseincode.com>
 <52291CAF.1000504@converseincode.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zHDeOHGDnzKksZSU"
Content-Disposition: inline
In-Reply-To: <52291CAF.1000504@converseincode.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--zHDeOHGDnzKksZSU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 05, 2013 at 08:07:11PM -0400, Behan Webster wrote:
> Replying to my patch email just in case it was missed before.

I remember there was a discussion of not dropping variable length array
support, wasn't there ?

--=20
balbi

--zHDeOHGDnzKksZSU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQJbWAAoJEIaOsuA1yqREIlAP/2FIdcR19mbqzFors7hEV5N8
p1kW4HN/pTNmQiFThQ7lWHyS/dVzrOTcaG4IixaMME28CXEZTGoAfn31XB3h3q7k
PeM4WwSDkW7DDG/EK9SUq1TsSeQiinHNWy5gUHFKHhbjyIAXDD+iGNwWFyffRYxX
XCxp9HHWVnkYJB5O5ZYqu4snu9TmbSiA2XgMn+x1gCthsFAH4dNDP09dyRLG4moW
Tnox2LM+ze2gHbNeP3TBX4/OJioucg90lw6286KjnqOHd85VFhNa7Mq2TKkhrwPf
pykBTIVcF44nPJogignFqWUCP0Vgaz5TH0VuC7Q4M7yCsmVM6oWlr1L19FuVq7Z0
5Adfug9m5+WjENk8BHA+wKMnY/36I/CHsqmkIFg3TJx9ooCngQ5KH6eLkmJwQKL1
Y9o3W3MT/HL8iJHebfGTU8MpqmcoDZZnNdQQU63vHFKkCPTK7Vx7BwBgyVrPTDQX
1Gh8pffgfOqTlEEIDnmFMgjM36hCJyTD7EELhfJ1zXLnSzwUfFm6WfsaNssx31OJ
3PqYAmO5/yBziY0rope6VYWz8dmTi1ndsDKdfYSg9yih+FbfuKgEgCacFfeNVHPo
tex8YAaVF8o7cGLEQtplKYe4GcDGPnxnc6wIycmtIdiNF1cuk90K9Xe/oYHOjOKu
KzSjgSibCYqZj6rn5pgW
=Q+IP
-----END PGP SIGNATURE-----

--zHDeOHGDnzKksZSU--

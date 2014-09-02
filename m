Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaIBRqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:46:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60709 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbaIBRp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:45:59 -0400
Date: Tue, 2 Sep 2014 12:45:52 -0500
From: Felipe Balbi <balbi@ti.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: gadget: net2280: Fix invalid handling of Reset
 irq
Message-ID: <20140902174552.GN16872@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409068819-11273-1-git-send-email-ricardo.ribalda@gmail.com>
 <CAPybu_0h+7PmUj3x+1ba5S3hnWQd3VH77_Y-u=pe7qhR9KsUUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TXIPBuAs4GDcsx9K"
Content-Disposition: inline
In-Reply-To: <CAPybu_0h+7PmUj3x+1ba5S3hnWQd3VH77_Y-u=pe7qhR9KsUUg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TXIPBuAs4GDcsx9K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 01, 2014 at 01:25:31PM +0200, Ricardo Ribalda Delgado wrote:
> Hello Felipe
>=20
> I think that you have forgotten about this patch :). It is needed by
> usb3380 in usb3.0 mode. Otherwise the device keeps reseting.

it's in my testing/fixes. I'm pretty much done with testing, just wanna
wait for -rc3 before sending more fixes.

--=20
balbi

--TXIPBuAs4GDcsx9K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBgJQAAoJEIaOsuA1yqREIlAP/A/YK+XJsPnCkSrLbzKc9nID
d3ooDifO33zOrw0XTU5+83Ffu0JDbrFyEhWNDYJbnkZqFncDLhgGotdpAVUchZFf
Do5xEco5GXSOThmVPpxX3WRPmzDoIXV/NYJe2RGKKknnUxBYmBfJGTj6gDG1SjRo
c/Tn21TOQ3BQXlX6uJtvk6tGIw2aDsFDbdEgakxNgQNEu8IBiNTpYegOMvNO91OJ
dd1km0uPOaC3tgNuWMCxAWBYrfQZmQuYrl6HJ4xkYpr2efUVn8Yr8r6er4tAmcGJ
2QW33G1qZPVLYr0W1lm6xPkmIn+6WXUVFhjYkJMc5KgrLgAOyON0SAvXrOvymeol
6hMhsAc09ky0skSFh/ugIRt10kFJoup13wxgLxoo1kOBvD74EHxHp+fv4YvTIlgc
OxeiWMB13cCUMXN2uJVyBRtUrDNUwEAAwM7MjjFNUbG53a+0+z/5XMDyZVmxa6KX
OZOpr9hDctH+x7PcQMYZ3LCKfRbTfBHH5aTM8Wwr2ZjWJyHFKHo6NNiuKjDekjxn
+JlnBS+F/S+WtHmFBk6JKNyjXrefZLiY+aOBsAwP1MzfTyLpElc19JfQy8loTSyD
0ePYDQuV34hbtNAPTKqop6XCL5dAJFOS6Cn2qNH6xtlPF+cYmxl+eU8Nf54qytly
JowEGNhmfzDPqqOIrFCi
=fASI
-----END PGP SIGNATURE-----

--TXIPBuAs4GDcsx9K--

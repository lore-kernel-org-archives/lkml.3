Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaCFQAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:00:44 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60062 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbaCFQAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:00:42 -0500
Date: Thu, 6 Mar 2014 09:58:40 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>, <balbi@ti.com>,
        <george.cherian@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v2 02/13] phy: omap-control: Update DT binding information
Message-ID: <20140306155840.GE25648@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394116729-28811-1-git-send-email-rogerq@ti.com>
 <1394116729-28811-3-git-send-email-rogerq@ti.com>
 <531896EB.1050409@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8vCeF2GUdMpe9ZbK"
Content-Disposition: inline
In-Reply-To: <531896EB.1050409@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8vCeF2GUdMpe9ZbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 06, 2014 at 09:10:27PM +0530, Kishon Vijay Abraham I wrote:
> Felipe,
>=20
> On Thursday 06 March 2014 08:08 PM, Roger Quadros wrote:
> >Move omap-control binding information to the right location.
> >
> >Signed-off-by: Roger Quadros <rogerq@ti.com>
> >---
> >  Documentation/devicetree/bindings/phy/ti-phy.txt   | 25 ++++++++++++++=
++++++++
>=20
> This patch is dependent on
>=20
> "Documentation: dt bindings: move ..usb/usb-phy.txt to
>  ..phy/ti-phy.txt"
>=20
> which got merged in your tree. So can you take this patch also?
> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>

done

--=20
balbi

--8vCeF2GUdMpe9ZbK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTGJswAAoJEIaOsuA1yqRE5foP/0wYc0zAXUKmUnXeIQC4VvCL
SJDG7OE0pbp+wFIqtufzn5W8W2HXGccpT4tTbvFxuFskIvrCLcTtYg5grU9uUJXE
fQcxghvpLD2i6JLdhaMfSUBngD2m1DEnOK5x7krzQ7O9xmS5C2/LOqWGSW0HXYlb
nEb7NxHvtoUCtkgBdfDxfEuJuBvOkJN2JmMNcyNvT7gz4l63XD4ijFhhbej9lNC/
XaEbVBzNSSdo/Y5Zl45wkL3JFpyuHCEsfQX7vf4III8ARUnLPiAZ1MHnI7puotwq
mstDC2XBxNqq9otFVoGs7dtXBItO1Fy1BeWtfByPhEnwCncYSklYM4utbMrIERf1
A1XbqDxKh+vgcl+4sfFcenFFdNEuIPT/fVukBKOHX8kmQ31kNoe8Qr8X30Q4abFZ
K41MqU1cGFYzTTroS1vkahlqIaqbddy88jn8Hl6MvrhaXoeop36zB/vEF75lO4+r
2hX13SlGLhVCR9IweUo3OB4rTGpaYbhlYAzwPiZ1jGgTvEpv83B6hNcVGJa4+ohS
Owz2Of50MiSBe7wEO4bx21H3sOgnakGp+xCULxN+g4wUYCZe+IiwAEftDkDEDv0s
y4OlP0GKeYBSWvbJ9XdLsc7AfGn/+rpnaBLqfijsD+da+oQFFlukkj5sb+5CEtkP
VCrOpuzLCyWOSBARZuUy
=4SrN
-----END PGP SIGNATURE-----

--8vCeF2GUdMpe9ZbK--

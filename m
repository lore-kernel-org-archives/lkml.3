Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaILRvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:51:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44861 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaILRvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:51:25 -0400
Date: Fri, 12 Sep 2014 12:50:39 -0500
From: Felipe Balbi <balbi@ti.com>
To: Andy Gross <agross@codeaurora.org>
CC: Felipe Balbi <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Jack Pham <jackp@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH v8 3/3] phy: Add Qualcomm DWC3 HS/SS PHY driver
Message-ID: <20140912175039.GH8567@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410542986-24419-1-git-send-email-agross@codeaurora.org>
 <1410542986-24419-4-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8/UBlNHSEJa6utmr"
Content-Disposition: inline
In-Reply-To: <1410542986-24419-4-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8/UBlNHSEJa6utmr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 12, 2014 at 12:29:46PM -0500, Andy Gross wrote:
> This patch adds a new driver for the Qualcomm USB 3.0 PHY that exists on =
some
> Qualcomm platforms.  This driver uses the generic PHY framework and will
> interact with the DWC3 controller.
>=20
> Signed-off-by: Andy Gross <agross@codeaurora.org>

Kishon, this looks good to my eyes. It has no direct dependency with
dwc3 glue layer. Can you still grab this for v3.18 merge window ?


Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>

cheers

--=20
balbi

--8/UBlNHSEJa6utmr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEzJvAAoJEIaOsuA1yqRElxYP/i1b2ui1IiVqjPvaEgIdY4DK
xPuA5LQzOVe3crpXEGjrC4OWVkvIBXq3sEXc4swe+A5F8Tq7iY+vJLbEjBMWdQcu
piXnYsyzGetxuMV0/B/B6bh92k+wzicG4egVwg/HJwSIQrdErkCY77ZS1IQ/US+V
4I1fehnXd+SHxpLQjBnVTtLZbbfnQU59KpqtgMaFVOmBFmUp7h5gUKJTcWIYv6JO
bsruKcFoLRn/vQwt5hIFrSqoL8lZ8yy4DBRtkAeDhmTWEJTZOW9lnzidqqoLkDcG
zSjAVVuJz8HfKUthXO79FnITyoNDDkTWVhvucbuSKoMtiRFHlnNPL8aWxdgi6P+W
it0eZ0IHp3EGD7AI6btqAsjr0U4HAPb4ZJfJX6iswjB0kaOvnM1717QNz3RKwqTz
Sih9FYs+CnTHWXbQ4wkWFr2VjnnkPnDm14Meyig8L93a2yvFK0b/lR8Hez/UDG1J
+R+JHcZS4vOKhdDviAjznlCv6/U/p+Jz5odk37gLas0mNpk51bFTvrFX23uT43XK
DNs3mSHjPTWG3IggfQHfSPz3wffHxe/kCGbP+XsqXCQpY/vlnD8cTomOARoU20rS
iylP/PBDSxhO8Bn80pPmseNQyZ2fCxUD7+hHSqjZEnHqxZLZF4du5DDiDEidK2wd
wKyd/7gu4EOGc+20MavL
=N+hf
-----END PGP SIGNATURE-----

--8/UBlNHSEJa6utmr--

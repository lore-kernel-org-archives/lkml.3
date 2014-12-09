Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbaLIDg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 22:36:58 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58608 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbaLIDg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 22:36:57 -0500
Date: Mon, 8 Dec 2014 21:34:26 -0600
From: Felipe Balbi <balbi@ti.com>
To: Yunzhi Li <lyz@rock-chips.com>
CC: <paulz@synopsys.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dianders@chromium.org>, <huangtao@rock-chips.com>,
        <zyw@rock-chips.com>, <cf@rock-chips.com>,
        <linux-rockchip@lists.infradead.org>
Subject: Re: [PATCH v4 3/5] usb: dwc2: add generic PHY framework support for
 dwc2 usb controler platform driver.
Message-ID: <20141209033426.GA11706@saruman>
Reply-To: <balbi@ti.com>
References: <1418093427-30614-1-git-send-email-lyz@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <1418093427-30614-1-git-send-email-lyz@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 09, 2014 at 10:50:27AM +0800, Yunzhi Li wrote:
> Get PHY parameters from devicetree and power off usb PHY during
> system suspend.
>=20
> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
>=20
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
>=20
> Changes in v3:
> - Fix coding style: both branches of the if() which only one
>   branch of the conditional statement is a single statement
>   should have braces.
> - No need to test dwc2->phy for NULL before calling generic phy
>   APIs.

please fix your commit log. Hint: try saving the patch from mailing list
and applying it with git am to another branch.

--=20
balbi

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUhm3CAAoJEIaOsuA1yqREziYP/R6wiSsGG4PRIxnK1zn/LT/n
lq49DYp35ajnfACjL8HXiLrATEQT2rMHm2lH3as19GpOxzTfz7EX380r9ZeiRSvA
RXBte3yu8PwuTGXJ8R6YwlbeNfgCn7zGCDl+h7tE/AfueoYuc9oWtMZCcQuo4g8U
YVPIOm+Os5jli+hIXvU/at3AEzEsCo48jFcYQu0UigHwU512axbB55c8AufCTNiM
T31+cZKWWxzY08CWIiz30GEKZVs/GBuby41oNFMIaR5W+2z/cR7xYB4wPixmHwTL
VrL3Yth/LZ8968T2/g5mDhT/wQsofpIGY4CG5ge0uniA26/2rHGIGdLP6rRMDj8g
iX7SCI6umEhMcMq1DJip+Z2kuFWns1Noq1+BbjolU1ckxfP2M39flu0YTrYJislL
HYjxCQLCKRiStCbkKD75XrtM3U3K5+odmejMh+SeJh8aWPHk6/yIs26s3i33344B
YzHwXMlm7heHbbKVFvGgpkYX7Gb0h1V/sRBBNNZysFHoYTq6WG7sCv0HGHzzQ3cX
AGn2PyPc6Uw2gbVx0neAE+FzR8jiJQ9hUGlrnjzRTKkSmiza5q7dAcliHzBGpJH+
dRBQY3YQXiQuDo8fM1KFiwWOdw5d/TPAvXdqb4MRoFh3AkaEiPH2Tao+WHTgulng
SZCXlw1dhagbb+sQDeAv
=u9eB
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--

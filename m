Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaHTOyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:54:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54012 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaHTOyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:54:52 -0400
Date: Wed, 20 Aug 2014 09:54:46 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Chen, Alvin" <alvin.chen@intel.com>, Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH] USB: pch_udc: USB gadget device support for Intel Quark
 X1000
Message-ID: <20140820145446.GB24500@saruman.home>
Reply-To: <balbi@ti.com>
References: <1407172974-22485-1-git-send-email-alvin.chen@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
In-Reply-To: <1407172974-22485-1-git-send-email-alvin.chen@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, Aug 04, 2014 at 10:22:54AM -0700, Chen, Alvin wrote:
> From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
>=20
> This patch is to enable the USB gadget device for Intel Quark X1000
>=20
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> Signed-off-by: Bing Niu <bing.niu@intel.com>
> Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>

this patch is basically just a new device ID being added to an existing
driver, do you mind if I add it to the -rc or you prefer to wait for
v3.18 merge window ?

--=20
balbi

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9La2AAoJEIaOsuA1yqREXFgQAIPaevVZsxEo9B6k05CEd/IE
KSsyOlV2ggH3obD4Q2B4BHwy+SDlwdLp31Rm/hePGJ9Z6LfTArG2WctPqmjk4s29
c8I5ZLwDlXd5FJggs8vI+tov1Eq37Mrgfye7mhIAE4X3p8Y5AfdMpXfSQui4BvV3
/iIejzfQ8MaxbeNp6/yqax3N8qbgSXrui76C2YfyuN6l47U291IRv8ufeFRfsEG1
JattLg/5/kZ+594aGtLzikNflbpncgJD9B2otVEJtp/ag+AwcCIxXjTCrcCLEEKK
+++9wz1fJfOBmOafPyTykkEapaI+D+ildP2h+wnzPGJOZyGvJ8uYEgkT75yR8cr1
Az+Bhd+y/JgZfKDngXB5zXCgUBsFpKwhbw8xpk9E5KRw8/bcM5dq8PxDt2HjjZM2
It1t3fygoZD1+KO+swK7nqbMcT19T1LBNKU4NCDjh1W1Tt7fQipidfcqoyS1Adi8
NZPw1kVjTuuGq/hglFeMDPVUHSi1on6rrOJRIqAq82V3D7R2dRDsVw+7xWiegfO8
pzSYODlrfFROPOBc7mztpl124yDRocjbt42rRjqMXu08YYjdA/t/Re6BIrwBV9Yj
RGGsHazprafaWy0O075G5tBf7oQSH9HXdiKXxPiP0QANt8y6tXDoPmrAZQ+YCGNo
VM1DbTHNUxwPw6Evj4Do
=8Jgd
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--

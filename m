Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbaDVOw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:52:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40776 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581AbaDVOwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:52:54 -0400
Date: Tue, 22 Apr 2014 09:50:33 -0500
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2] usb: dwc3: core: Fix gadget for system suspend/resume
Message-ID: <20140422145033.GG5524@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395826989-5405-1-git-send-email-rogerq@ti.com>
 <53565F8C.4050100@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zq44+AAfm4giZpo5"
Content-Disposition: inline
In-Reply-To: <53565F8C.4050100@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--zq44+AAfm4giZpo5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 22, 2014 at 03:24:44PM +0300, Roger Quadros wrote:
> Looks like we missed this one. Could you please pick this up for -rc?

see http://marc.info/?l=3Dlinux-usb&m=3D139809466025568&w=3D2 , it's already
there

--=20
balbi

--zq44+AAfm4giZpo5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVoG5AAoJEIaOsuA1yqREQqwP/iGSve2m5NN8oc/XbNQj750C
RDC3ct55Cpho//CYL8ZO6GvZNIOnivl/tAp5amAF7ujXYaKHpgx4A/KMFXy/wDkm
ZRA6mUvXZkh3HCmV0XQKEhnOquD7SJp10Yi5Ad6/w6bS/MH7wKVASYYskdfGmlSk
l5HtNNHRwGGdYS+gCBV4p+QdcgB8+Wrbh6/Sj8BjiEWG6DyoVt2Q8I0nTD9fqR69
UEE1oG7gToqyt/U9oh/FYknolZ1wkTa6yycB157X1gxAEILpDUlMm1O5HlcqWNhO
V4MKdwxhYFZFsyyPZExVOLMJ7nkRnt7HFgdXo9rKkYDY4TpsJPXmCFE+pCRmsOxg
xiXOORf/dWZxRTr//RCyQVFjVFfJoU7Ux/ym0X1VYdsbZIbEe2KIiQi/XAT7btZw
BSKlVg0ITTpExD+ci8sO/+a7FjPR/Ktx6ngB+0le0rlS1kmiNInErgshh6y9V+KT
EW2ASktMeTl5QDxCifuJrmzPbDxq18H0YzkjX/mnIM26a0Qa69cO0mPuD5nniHWc
Q2KYGLNhzM0bL9UEbZUHKasJD0FCxM+/iZfvfwFAWngrX4VLyf6qSx0P3cKxUw3l
k5nIcvo4l4+lY32RXTIgBHBVHasrjye1PocuYY2bTNtWpMbZY7dc+23DQkXOLZ4h
xbLuyOjDq/Pmjqxlq7o+
=T16J
-----END PGP SIGNATURE-----

--zq44+AAfm4giZpo5--

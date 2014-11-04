Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaKDOrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:47:00 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60942 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbaKDOq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:46:58 -0500
Date: Tue, 4 Nov 2014 08:47:26 -0600
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Tony Li <tony.li@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: remove warning of disable scramble check
Message-ID: <20141104144726.GD24983@saruman>
Reply-To: <balbi@ti.com>
References: <1415093391-4569-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WChQLJJJfbwij+9x"
Content-Disposition: inline
In-Reply-To: <1415093391-4569-1-git-send-email-ray.huang@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WChQLJJJfbwij+9x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 04, 2014 at 05:29:51PM +0800, Huang Rui wrote:
> Some SoC's FPGA platform will need this quirk, but it will complain if
> running at true SoC platform. This is a normal case, so remove this
> warning.

nope, why do you need disable_scramble on actual SoC ? Without an
erratum number I will not accept this, sorry.

--=20
balbi

--WChQLJJJfbwij+9x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWOb+AAoJEIaOsuA1yqREkEwP/RVs45HII5Rnr5lZ8VBGE0Tq
dOLFcrw7cGUF1Id0kIrbKYlBbMn1p40Qgf1rM03SB1PO96fc3i1JsqJQJs+cow8K
Q0YJwF/ThkRjLwiJYnm52De6sywDtQMrGJcXJv59nkRTRx66j9EMRP8sglkX4F/S
vQToIj+IIeKDXjUWVY6/qtX8kncRRmVDg0UlkG8PRmvfWkbAWi+tNIUtiQzChRzG
0vSqX/KmSsnbQvFVS4GvyQ1LxZNePxebo4PLqLyXT5Rs3FdNTwp56pnG9/ZEhs+s
tmoX5Vvo/BMqx5TbnjKLZQn69ke9pAwiMW1nS9xMb0k863O9YSsX5caL8dz03/Bt
280AWOaRH2CQ7Wkk0iW05KcMQAqjRSGPs3IOPBK8GdAt4MI+hAHOvL0mhDGLerZl
Y/TgkRl+mXNgT+UHh+M8MKaXZDYLWszMthVphU18P0Iqu8y8bx4BEMnVxnmjUGwn
wSJaj0xO3b0r4GkkVJwAghfqIuLC2g1Xb51prQf4+F3sC05uUz+TuHhMgXBaQlvc
78Smcf1KqWmv4AXX0hwFXKImJKUZ6LdBDMH5FeWf8BZLbMio6shNZEzebq7UzGHn
ZM7y7/6SD2KpPV2rYKkXLn+ApiK+nVUQOmeMnvXJrbIsKkiXmZ5BIoU/tGOSn+TS
joF2wUsSawRbvictAWv1
=zKeR
-----END PGP SIGNATURE-----

--WChQLJJJfbwij+9x--

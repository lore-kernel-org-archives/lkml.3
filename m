Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184AbaEWVFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:05:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57143 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751038AbaEWVFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:05:15 -0400
Date: Fri, 23 May 2014 20:33:39 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com,
        Boris Brezillon <boris@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH RESEND v4 0/8] Add Allwinner A31 USB support
Message-ID: <20140523183339.GC10768@lukather>
References: <20140514160520.GA4679@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yLVHuoLXiP9kZBkt"
Content-Disposition: inline
In-Reply-To: <20140514160520.GA4679@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yLVHuoLXiP9kZBkt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, May 14, 2014 at 06:05:20PM +0200, Greg Kroah-Hartman wrote:
> On Wed, May 14, 2014 at 02:34:19PM +0200, Maxime Ripard wrote:
> > On Tue, May 13, 2014 at 05:44:14PM +0200, Maxime Ripard wrote:
> > > Hi everyone,
> > >=20
> > > This patchset adds support for the USB controllers found in the
> > > Allwinner A31.
> > >=20
> > > While the design is similar to the earlier Allwinner SoCs that are
> > > already supported, a few details here and there change, like the fact
> > > that the PHYs now have one clock per phy, while it used to be only one
> > > for all the PHYs.
> > >=20
> > > Resent adding Alan Stern's Acked-by and puting Greg KH in the
> > > recipients this time...
> >=20
> > Applied patches 2, 7 and 8.
>=20
> Feel free to apply patches 5 and 6 to your tree, as your branch needs
> these, with my:
>=20
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> Or, if you want me to take them, just let me know and I will.

It looks like it's still not in your tree (or at least, I haven't
received the usual mail notifications).

Is this expected?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--yLVHuoLXiP9kZBkt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTf5SDAAoJEBx+YmzsjxAgpSQQAKW7QArRpswHvz+TDaxlwf1q
wc0ivvzAQq7v7TN42R2EHCPomtLgFiXV5lvHWFbbXSQ0/clKss4s57+gZ9J/Our9
Gobih9bixi3FhcnNR/ByBke5NjZTw6pHWmq/8QLk/Yi/qcWF4mA/KdrKKwDfyI0A
vSRV1REl96OS7CpefRhT1vALK4qNUAivN9VT5IHhEZkES6oy08hr4NVAxtAlv3k9
ZAjyjt8KSzvOOAetNg9gqo9qIEW7rHdWL9g3ZGTblsfS+bNVoYt6P0l6WTVjgTin
Cre0NB+LQycGMgB0Q47AFC4q/BGrB/cY8vDJySRtF4yTkbWV04x+pJMbEETpty9H
QCpd/V0q9ovvOYloA9HzyMeJAZXnnst6RcfRoDiEPbnl+8msSzR6VVxpOg5lSMon
ixNqy9HsZCRnmeA+k67BKgYr1Sh1dGF99Ovezo+LcEFjAr9r70G3ZSTAJjmI4m9I
jmrI6ZS2VASoXEXd/54Zf5FHXrdYgOtLbTYoXQgnZIsw5WpI1yac3dNNWSsXlI7U
90KJpKGMSl/svlnotcvEaWsTn/xORYtSFB6feGGX4ksO/iPZZny0lzeMNn5rJIRV
O1huwYq3fotkRaXXFrxiJ8ygOF5Oq56iF+TGsohhfxd6b6dWq1LsMEXqkIB4ipwF
GRb/839vorBbSgK4dVdd
=+WUb
-----END PGP SIGNATURE-----

--yLVHuoLXiP9kZBkt--

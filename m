Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab3JVMvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:51:42 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:61748 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3JVMvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:51:40 -0400
Date: Tue, 22 Oct 2013 14:49:06 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Zhang <nvmarkzhang@gmail.com>
Cc: rpurdie@rpsys.net, jg1.han@samsung.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        tomi.valkeinen@ti.com, linux-pwm@vger.kernel.org,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to set fops in "struct platform_pwm_backlight_data"?
Message-ID: <20131022124905.GA24255@ulmo.nvidia.com>
References: <525F8895.5010806@gmail.com>
 <20131017071445.GA2502@ulmo.nvidia.com>
 <5260BD8C.7000200@gmail.com>
 <20131022072443.GB8681@ulmo.nvidia.com>
 <52663D6D.5000806@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <52663D6D.5000806@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 22, 2013 at 04:55:09PM +0800, Mark Zhang wrote:
> On 10/22/2013 03:24 PM, Thierry Reding wrote:
> > On Fri, Oct 18, 2013 at 12:48:12PM +0800, Mark Zhang wrote:
> [...]
> >>>
> >>
> >> Okay, I just want to set the "notify" function pointer in "struct
> >> platform_pwm_backlight_data", because I want to tune the brightness
> >> value before the pwm-bl sets the brightness to hardware. I don't know
> >> how to do that, unless we define the platform data explicitly.
> >=20
> > Okay, my question should have been what you need the functions for and
> > why you think you need them.
> >=20
>=20
> If I understanding you correctly, I suppose I've said that: "because I
> want to tune the brightness value before the pwm-bl sets the brightness
> to hardware".

Why do you want to tune the brightness value? What are you trying to
achieve?

Thierry

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZnRBAAoJEN0jrNd/PrOhMn8P/0rPr2bbg6VRri7K1nW0p4DR
0BoIiodZcUekOCznhN/P2R53Jwmdyc/F/52qC6djOOZY+AacanqkokGXw5cqcmHm
qCIQTX2wBiRBqQbVqyUiIejihaDwfZqSCh4QdGruJ+Gtv1oEGfaTX+jBCIcWMzgi
K024jvhVGJFHfrAW3v1IFmSELljt2j84fw+ZCZ+xmnLnFysOuxgGGl1pwz+sEsm5
71vjHbtuad2uUED+X4mgalmhEPH7vxiiv32RvlP+BHOFxrcqe2Z6PvW1jticqJQ4
z0lyfHOxkHDRASLGcQ1gJl5aSUCSGrnczLCWCl8wMDMkNyhEsU8GSNE1zGAo65Dw
HyvVNkMswQeS9QfIcdvOVYSiO62UtXr09jiuqe1Wy7zX9NbYjjgbkkNLjbbNM6BP
BZbMIqxm01MVKsRtXEOI9vcuM5uxiEucatNJV8mMwVkpSR34dmyKoCZlWR2q7P7e
oLnK+nRC6UocW1N27q2vwA7Hw7wiQTNeAkDv669BD/6715kTLoiSYRds/xqGe22d
O0ju9vVx6sD4Fez5JyM3sUxh/s5zf8BqqJdwFSY1Vu2wdaty7cwz1NT4FzKCYnej
FiRdEbsHSX8sMhy5wyjUgCrT7sSBRRDGzZawa8kYqeW+p3AX3v8GaqolmpVF8CUn
rVDkah6V8Dsv9u/Qx0GS
=71Hm
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--

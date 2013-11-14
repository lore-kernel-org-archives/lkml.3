Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab3KNSGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:06:25 -0500
Received: from sauhun.de ([89.238.76.85]:34640 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab3KNSGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:06:17 -0500
Date: Thu, 14 Nov 2013 19:05:38 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Benson Leung <bleung@chromium.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, khali@linux-fr.org,
        andriy.shevchenko@linux.intel.com, jacmet@sunsite.dk,
        linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Duncan Laurie <dlaurie@chromium.org>
Subject: Re: [PATCH 2/2] i2c-designware-pci: Index Haswell ULT bus names from
 0
Message-ID: <20131114180538.GK11022@katana>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
 <1382326010-4554-3-git-send-email-bleung@chromium.org>
 <20131021065804.GX3521@intel.com>
 <CANLzEksGqD30Cefh3r2urH-ToxWzkxAnTJZiY07yX2Py58FQPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwbb4r/vLufKlfJs"
Content-Disposition: inline
In-Reply-To: <CANLzEksGqD30Cefh3r2urH-ToxWzkxAnTJZiY07yX2Py58FQPw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwbb4r/vLufKlfJs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> In the chromeos_laptop driver, I do by-name matching of i2c busses to
> find busses and instantiate devices, so there is value to have each
> named something predictable.

Any why don't you use fixed bus numbers which you can attach the devices
to?


--rwbb4r/vLufKlfJs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJShRDyAAoJEBQN5MwUoCm2CBwP/0a1exmWGyB60VLyp8W6+dLa
XZKZfPfx8ogv0LfCjrfOiyxs0nzmKH2l9nd7ab6PbDdJgbvzYZ+IvmRh+J9wH/A4
kOFnAGSwF3xOIx+RLil+e/J6MZ7auaNYIhMKD0orBAkoVoIv0xP3rL68MibQ6N52
W0CJTWFCaj3XhzOLOtu0FakkPzhzAF1ZoP/B/sBgjs0TVWVn43MbfdtklpOEEtJK
APvgb/oG7cCTTPF17IrquEVRFIWbewvsNJHxt/wr9CSKvWPobKvIsloQ5u5B0Ys7
n4rhiI+rjckUW3YWIeiqe1+SHdMFpbypWjWXXRi30YQTIF3mWjiNBxYTODzvAyu3
pzU+cmTovS6csbXRWLlh5Y2OMGkoQbJeQk/DuezNEkfCxZQbZLfBFu/n5MC0n/mT
rinu8ddHSG89UDI7EatISGYxfMEgg5l3DLQrUbMlovCMCxxP+n7GXwx8H0scoS86
zKedbQy/Rfh4lxLXVksgiNyJbe8oUtZ5rPFT60ew1dxWtWFHTjIB2G4YrvRQjpEd
IFahtezYutzzzB3xuhtY+lEqxevKlRROZcH/1pdT/rvs8wXgZL/R2B42AqFtg+Up
oq7QitIepFGovD4dz62JWDQWan0QJf7i+7WY4hLxUm0hTpgHV+57INGkLIpQF2xm
6vCDDlU2H4ij5QP3dcc/
=yv6l
-----END PGP SIGNATURE-----

--rwbb4r/vLufKlfJs--

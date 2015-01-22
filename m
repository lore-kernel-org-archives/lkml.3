Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbbAVPHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:07:22 -0500
Received: from sauhun.de ([89.238.76.85]:41575 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbbAVPHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:07:20 -0500
Date: Thu, 22 Jan 2015 16:07:17 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-ocores: add common clock support
Message-ID: <20150122150717.GJ3413@katana>
References: <1421230899-7843-1-git-send-email-jcmvbkbc@gmail.com>
 <20150122144522.GF3413@katana>
 <CAMo8Bf+XJY_bY+OB2i_SZQmAavwERG39BR8FVj202V-E3UidPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P6YfpwaDcfcOCJkJ"
Content-Disposition: inline
In-Reply-To: <CAMo8Bf+XJY_bY+OB2i_SZQmAavwERG39BR8FVj202V-E3UidPg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P6YfpwaDcfcOCJkJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> The clock here is not the i2c bus clock, but the clock input of the

Yes, what I would expect from a clk-property :)

> controller. The function ocores_init initializes the prescaler register of
> the controller so that the bus clock equals 100kHz (internal clock
> runs at 500kHz):

'clock-frequency' usually describes the I2C bus speed. So, for ocores,
it describes speed of the clock for the controller? That would be
ouch...


--P6YfpwaDcfcOCJkJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwRIkAAoJEBQN5MwUoCm2Qs8P/2Hm3chw5OIqogevga/Hz/Ei
mf3MYH8PNihgJfvqAwnfFENQWY37gwQTGuIV00s/h+3FJ4W3JISgSosipXQ9B0qy
f/DQU1TZVkbDWVA6xDljBW32U6JRLbK4V9+bzsJNPhNChVoNLkbHMlZcWCitMO0C
RqzFAUnhupvxYmFA1a5xJ7n8ttdLYnOj+qSdF++lCoHynqVHmsXOdIroNvpAjvLL
qlf1Y0Hw9TM/LurooVL5iiVfPpogVjQ0Puup8I/X5vjrUukF9rKJQEfxNNjLpSzr
K0ech15w7yauAwoFiFRv3dkYn6YTJGxeGURK2qvKkhGGzzMF9clsi4pwK+NXxNnM
xMP8azVjeEyTbOL27TubB+0qAFyb+KQGq6D/yQlzkSQ0OBcAQztY8ggrC5K0ROM9
FEVGNmv1DA/hw62EsX2TyKSpIT0v5Old1ekkjEyfGnlbK+pgUnk6qZDbluCp/zDB
/YjwcGMD1kv6JYjeb2bqso9mH7qfSXbLllW3WcenKx6w24vPL6PjLYb5+pygZ4L6
eKyhM1K9VWEFV9ddbjljFdcRV6X8v8LC1hnG90/24jyHMcH69Y+6zmFM/XX//dhX
2ie5aFTy7C4tjh+Z6UR6/2RF+7TedISKfSM6owBcgMkOIPuCpUCejOCPgDxE77D4
SE3mZI0Ndc8Um7mxx+E9
=+qix
-----END PGP SIGNATURE-----

--P6YfpwaDcfcOCJkJ--

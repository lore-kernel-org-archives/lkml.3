Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaCJPYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:24:10 -0400
Received: from sauhun.de ([89.238.76.85]:34007 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbaCJPYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:24:09 -0400
Date: Mon, 10 Mar 2014 16:24:06 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, nsekhar@ti.com,
        khilman@deeprootsystems.com,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] i2c-davinci: Handle signals gracefully
Message-ID: <20140310152406.GD11592@katana>
References: <1389265885-26777-1-git-send-email-mike.looijmans@topic.nl>
 <20140309202107.GA2835@katana>
 <531D92F7.7080509@topic.nl>
 <20140310105952.GA7227@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6WlEvdN9Dv0WHSBl"
Content-Disposition: inline
In-Reply-To: <20140310105952.GA7227@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > >Even more, you should complete the whole transfer. There are devices
> > >where things can really go wrong if you send a half-complete command a=
nd
> > >then start with the next one. So, not checking signals at all is the w=
ay
> > >to go for I2C drivers. There is some cruft left, so I am happy about
> > >patches fixing that, with testing on real HW. Like yours here.
> >=20
> > I agree.
> >=20
> > I know the Zynq (using a cadence controller) also lets signals
> > interrupt I2C transfers, so I'll propose a patch to Xilinx and CC to
> > you and linux-i2c to completely remove signal handling from that
> > driver as well.
>=20
> Cool, thanks!

Are you going to update the davinci patch as well?


--6WlEvdN9Dv0WHSBl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTHdkWAAoJEBQN5MwUoCm2VT0P/3F5lD+Yiw+m2x17QxLIQaNc
uC9dkimWVbgnRZAZL4VBRHcO0xIRV1U+OMA116Ab/AwGUluTJsornmGa2Q/Z0IKr
rNwHxr+VfMp6T3YSNpKCxwOp2Jim8qBSJlWcwTRUwzqmSrozb2ZKlU3yjl3fa5Q7
DrFqPKtbn5FABVYXqj7vrXRLkLtWK6rvScWNOLHRXcit4W4g1fNOVRdDQ5pvF4qD
ierRoiMX0CMJOFK8xi+T3H1zSKHAF5l4KY1ebKUhAV1cPmtJhcvpsYuKRZYOrltW
uzMVxEOuNuIpfMI677MNT90D99pokIxMMx+772u5Q/HZqqhk6fpuEkYonSDRJAjN
/dSP9Cfm3qfFKPxEUbhIR8hZRHC0yim92ySuss0kXv+qkuowbYAjrPat53xle29s
U0DXEmNz4VYsohrBe4SpBALLshZmRWt7QrYgXjCjibU2SRbnh6x/ZGq0WcYnm/3l
qi1XfJP0GEL43Kd/fnYN+eRwI7RnlmsBk3esn8A5lfgL9JtuIfy+co3rTfCVCMhG
7/Jq3ZJlOCgEIY0Ko8t2x3YLdgZhkRZzlrZ4FNvWFZoEA0L32akHiIPWcl8gAf2H
pPrl7s+BhPdVK/P9grc/GgQSnHRMPMgGOTZ3D8fqX25TzPluZzZ/Ra8nXO9PY4t1
P0JnNkWXOdsaPF7jQiLl
=0ucm
-----END PGP SIGNATURE-----

--6WlEvdN9Dv0WHSBl--

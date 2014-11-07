Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaKGSOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:14:03 -0500
Received: from sauhun.de ([89.238.76.85]:55958 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbaKGSOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:14:01 -0500
Date: Fri, 7 Nov 2014 19:15:05 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: cadence: Remove .owner field for driver
Message-ID: <20141107181505.GK3656@katana>
References: <c076984af7e65c433fdfd3a3b0f8d20da2c18013.1407931005.git.michal.simek@xilinx.com>
 <20140920091106.GB1612@katana>
 <541FEDB5.7050305@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HmK7y6O+lKZIGkr"
Content-Disposition: inline
In-Reply-To: <541FEDB5.7050305@monstr.eu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HmK7y6O+lKZIGkr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> oing this for the whole kernel will be the best. coccinelle script
> is good option I have never played with it.

Thanks, but superseded in favour of a generic solution
(https://lkml.org/lkml/2014/10/21/594).


--+HmK7y6O+lKZIGkr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUXQwpAAoJEBQN5MwUoCm23pwP/jlhP+td3WZv5MpBOwu+p6Jr
BW5rT7iau7GvdjQZ0zFsmdG40d+mIRO8McPylNiU2SXm4V/zWEoItO0UPHFgLR/s
saLTUYLwaOZ50/GlZA5KUrRJMqRrb/Joiu2mDVlAKnmmBC/L0cCgOkSVm5z3PXWZ
Gs09Geh/fRrFKTvT8QngeUnLjKJ6JQD9fgCtRZb0pAadXuGjAra2USve0tREnsqn
UU6Ikqswqg76HnARDh2psNKEP8iof1atSjyJ1/LP0uZ/cR23paQ9K7P0STzoCBi3
1Zjxi9bsxjUlEIREbeC3zEaRME68qAYobSAIM3FeMxqNqoHe4RPuJF/K4Hm7xIEg
8X7Xzt9FXvWZy8JgmW/fsGkyJtkXJRHQPa85IgllWBMIIhm+dE70z5iRuhAlgHV4
6h3CdSP4tx90jXNee3pvXVLF3Sgr24ZKn+nFuxDxdVUsu+waxd0Oo6i/+V5hWTtq
nsxYXHLH9kxrdHb1mxjlK+fxcMlTl2na5hRr9vqwpZVDS8XM+tY8as+Icub/mWWJ
PL5rrE0uzyd3lZ4MZdgxPiLjPbL9o2hdBt4l24satrgwoQL+HjWOc9bkO2AR3RU6
MXxN4DqRIjxaM9tGB9iAR1/6Y1hkFWZuJQlV86xEwDLkIjSmb8yZV0V3QIemyP2l
At8JeKR29sUHh/0IgLT9
=FJy8
-----END PGP SIGNATURE-----

--+HmK7y6O+lKZIGkr--

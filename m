Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaCGO0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:26:19 -0500
Received: from sauhun.de ([89.238.76.85]:50073 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbaCGO0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:26:18 -0500
Date: Fri, 7 Mar 2014 15:26:14 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux@arm.linux.org.uk
Subject: Re: [PATCH] i2c: mv64xxx: Fix circular dependencies warning and
 compilation breakage
Message-ID: <20140307142614.GC28943@katana>
References: <20140307111858.GB12274@katana>
 <1394199795-5516-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140307142405.GB28943@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
Content-Disposition: inline
In-Reply-To: <20140307142405.GB28943@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Why don't you simply set rstc to some ERR_PTR above if not
> RESET_CONTROLLER?

I know why. Sorry for the noise.



--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTGdcGAAoJEBQN5MwUoCm2sPcQAJw8eV5th8WRozVoBjQiDdKA
al3HTXFAu9VugGb2TtxzjKmhYSjQaBtfwfSNvuLzyEDK1gYSOFKndgkq27PCvNWe
Ze844w31j/b5XAW4R0v8g5E1cEB0RtXIlTXHc/eOl4k0Je+SVRSDWTWauXYt660c
/i+haEXpt2SaNLGzAKRddV/tTUTbW7Wa5Kt1GStZLTPF7oskg9nuUJeKqzR6zuk4
jP1eTLk5S+iWug1eFCNeOEq5IA3Kf69w1BUhLFRymOPBkG7RdrgR1301LLBnVjGH
CAs+6d65JCf1zGoGJk7DwFqS3E6qVLik2/S0PZ/faRxHj5myhGVDzjV07pkCrqJB
2yuOYgZwirTK8vvOiH1fbeWLc77jvmeV5wOPEnHMK3g2P27hl595dpHbRGPbS0Ys
8jhI9jTT5KpJpvuMySUZDsmyBcQZ2lb/B99USyqzH3T0MLEk5+Jkyr5+cmIhdgAu
z6dG41xRSFqo1fqr9P82h8di1/LrP9gFU6RX/6W2s1fChJhFEoF4QrYE/EzCrB6w
13yMJGMoGf+UjLJ5c22IDYz/YhVtSeW7ZcUOdi4SJtB0cR5OgbdUpVhfnuUIA1F6
E6WeNW2RG+kymveH6zoKstiPJ9ms+r95hCEOY/jkplKlNRfpWtSu5zMwBDIbE6H4
1JfHjR8OIJBMyk7zb9mz
=rs11
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--

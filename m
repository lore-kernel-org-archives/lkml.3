Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab3KQRbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 12:31:20 -0500
Received: from sauhun.de ([89.238.76.85]:58285 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab3KQRbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 12:31:12 -0500
Date: Sun, 17 Nov 2013 18:31:08 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Andreas Werner <wernerandy@gmx.de>
Cc: khali@linux-fr.org, jacmet@sunsite.dk, hskinnemoen@gmail.com,
        dianders@chromium.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] I2C: busses: i2c-eg20t Do not print error message in
 syslog if no ACK received
Message-ID: <20131117173108.GB8577@katana>
References: <1384678731-10399-1-git-send-email-wernerandy@gmx.de>
 <20131117110846.GA3093@katana>
 <20131117123902.GA3834@awedesk.fritz.box>
 <20131117121809.GC3093@katana>
 <20131117165329.GA1562@thinkpad.fritz.box>
 <20131117170838.GA8577@katana>
 <20131117171623.GA3947@thinkpad.fritz.box>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z6Eq5LdranGa6ru8"
Content-Disposition: inline
In-Reply-To: <20131117171623.GA3947@thinkpad.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z6Eq5LdranGa6ru8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Sometimes its really usfull to look closely :-)

I can't do this for every patch right from the beginning since my time
is limited. I usually start with letting people sort it out themselves.


--z6Eq5LdranGa6ru8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSiP1cAAoJEBQN5MwUoCm21pwP/2g/nMK3ZJDShIdo10EUrCgj
pGmLnD9DGjNQhnh1rc82OpRtpSB1FNFB7x1IYewyfMWfaCwrGAz48cmKWVzUSJNH
WVPQrlTvbDVaIklyj3G3GDqxrK9MI265yEDEqP6vD+wF5B37mgRQk2jPHftZ/h4W
FKecllutSkbIftN3QLOJddtDyyi/6D2Xfkn4PtDbMhCeHTgQsrBjzegK8zlBPplq
8SkEfjTaPq8WJvOf8t0293DrlP4xwsK4Z4ZCAtFXPf12mblB5xWsgn5zgf2xIWsv
KBMQ17VSKbyM9sRNxDykkAQth9PO+KvTaonSBwbeMEOy7/UrGOt0teyBwJmtTCTL
2g5OAz/cP7ZmXf2GwFvOzfI1Uxb9VHbdxpEDfy6euGI70GdFdgtgMYd62QbIwIHw
lMMcxZbBee9IakEmnMeUk3sc/qBq3lhvdQhZBtC6UPRVb/hqqpfqFJuwPHZ9q24Q
Cf0SoCCjxinfSsHiAHshd3veS7uBi6dh6zAB7D0CXm9MjS+rJ7vy4UGnJb3GvLBx
mS89uwizgpr8iiFV7z0Ht1+C23NSMiiWQyJjEfI5ZvAq1y97x4i6SZWvp9o61jm9
4f+T8WD0wP25xQ2x8I6Wb6Q7ZSSrUH6LmKYkW6Qy68VyCZsXLjrkYA379015Q8UR
DeVVCe/waixFsNGUFSZW
=iOEH
-----END PGP SIGNATURE-----

--z6Eq5LdranGa6ru8--

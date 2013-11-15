Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3KOPKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 10:10:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61855 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752645Ab3KOPKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 10:10:18 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Len Brown <lenb@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the idle tree with the pm tree
Date: Fri, 15 Nov 2013 16:22:45 +0100
Message-ID: <2690209.ruZJYkdcbR@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131115122329.1479981f032f0f863c786c84@canb.auug.org.au>
References: <20131115122329.1479981f032f0f863c786c84@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1564366.AfdsgCkGpe"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1564366.AfdsgCkGpe
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Friday, November 15, 2013 12:23:29 PM Stephen Rothwell wrote:
> Hi Len,
> 
> Today's linux-next merge of the idle tree got a conflict in
> drivers/idle/intel_idle.c between commit fab04b2208dd ("intel_idle:
> Support Intel Atom Processor C2000 Product Family") from the pm tree and
> commit 0654c50d7a0b ("intel_idle: Support Intel Atom Processor C2000
> Product Family") from the idle tree.
> 
> I fixed it up (I used the version from the pm tree since it was much
> newer) and can carry the fix as necessary (no action is required).

Thanks for fixing this up!

Rafael

--nextPart1564366.AfdsgCkGpe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAABCAAGBQJShjxLAAoJEILEb/54YlRxTu8P/2a9EUFJm+gAMg2cluUbOjmr
xROlRpRgI4WbfKYmarhMJcds9gCjXO4ZQp4ARmdZ+UwmEykLexfBXeDHq0OtWJDa
lEhWlHY6CdNtpRAqccA3wxr9QNhH3DFR5wSPq+UPRt+ESjkgInLlXdD0yquyJgZm
UfOweTmxs9cwnEAiitvKU9l8O4CSx+aBYa0MTUSrw6v3iKnE33G3jF6pGsTfjp6n
fVlg1AlRNwmnkagST6L/vuckwQ8fVZKXoTh+3lDv/TA/JXDT3dMuiQb0TmQz0vuZ
/RHna4CQIeIo7nLRrIYwczGxIjWNKVgwN9aJx15XJVOsNXryiw3V0iwGmhQ/4Ejt
PmD20pE4ug9QQSnM0p9AAhG5oV8sIXZRjVi/ZyJE1dPDO9SnEFACj/GTqdEiVtse
XgSEXBkjLYNsh4UfmC/lAtHhRr+HhENVCmhsAsoT6PCrX9qObGIzRm+ekETk4s6z
+CVTSf0ypcPSUDIBtnpSuvFXnkRM/hLquP+xggm8n6VqPNwfGhH0uDai57pMyj5O
cAZ+RSh4Gs8K9GBlDHtWuzccnnOd1kwQUyMlKcjm+u1DjqBn9jpRC4X1N3rT5/+Q
A1pHJW1AVoo5Ywr8y5S4cIgRQbGJq8mDY7aXXZ0B0dJk/+lwFKtne/0GrBWcLZbN
RIKfipA6YooPItxKtiQf
=PUxe
-----END PGP SIGNATURE-----

--nextPart1564366.AfdsgCkGpe--


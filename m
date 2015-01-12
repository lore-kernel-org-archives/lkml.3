Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbbALW0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:26:10 -0500
Received: from mail.sf-mail.de ([78.47.74.12]:52849 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbbALW0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:26:09 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [3.18 regression]: machine hangs on s2ram
Date: Mon, 12 Jan 2015 23:25:53 +0100
Message-ID: <2305933.d9Q1kE20bI@eto>
User-Agent: KMail/4.14.3 (Linux/3.18.1-1.g5f2f35e-desktop; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1729079.GxnV52A97m@caliban.sf-tec.de>
References: <1729079.GxnV52A97m@caliban.sf-tec.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3373955.mIciv9LGMt"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3373955.mIciv9LGMt
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

> Since I upgraded to 3.18 my machine (W740SU based laptop) hangs when I do
> s2ram. For me it looks like the preparations work, but the machine is then
> not switched off. The only way to recover is a hard powercycle. Since the
> machine has no serial port I can't look what's happening then, but the logs
> do not contain anything suspicious until the point when the machine locks
> up.

Meanwhile I see this on a different machine (Core i7 desktop), too. I'll see 
if I can dig out any more information there.

Greetings,

Eike
--nextPart3373955.mIciv9LGMt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlS0SfUACgkQXKSJPmm5/E5rVQCdGdPuuF1QvPDLjn6jGkoaNxbW
w8oAn38g37Da2+Ipmet7NQP3Uh8ZiWlW
=CBmh
-----END PGP SIGNATURE-----

--nextPart3373955.mIciv9LGMt--


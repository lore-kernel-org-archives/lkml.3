Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaAZV0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 16:26:09 -0500
Received: from imp01.mtu.ru ([62.5.255.10]:40803 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbaAZV0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 16:26:07 -0500
X-Spam-Flag: NO
Message-ID: <52E57D42.60206@pavlinux.ru>
Date: Mon, 27 Jan 2014 01:25:22 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.8-rt11
References: <20140125134519.GA9845@linutronix.de>
In-Reply-To: <20140125134519.GA9845@linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="jfKKxsauufOwfRcLkA7E0QNtlnat6EhHh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jfKKxsauufOwfRcLkA7E0QNtlnat6EhHh
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

25.01.2014 17:45, Sebastian Andrzej Siewior =D0=BF=D0=B8=D1=88=D0=B5=D1=82=
:
> Dear RT folks!


Gentlemen, let's have a month of stress testing!
Divide tasks testing subsystem: USB, NET, MM, ACPI, AUDIO, VIDEO
By CPUs: ARM/PPC/X86/X86_64...

Purely on observations noted that in September 2013, the quality and stab=
ility
of the code has deteriorated dramatically.

--=20

                                                         Pavel.


--jfKKxsauufOwfRcLkA7E0QNtlnat6EhHh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCgAGBQJS5X1DAAoJEPtok08Dny2hsjIP/2DqresRa9Ymrn1CisClRotJ
1mUeRnaSmX0jV0M+qvGze3XJWpmEZBqnvcH2YsVRCVtjdn3Al8qkXpukWqepA5+R
YjW7jX0SG6nXrEnEqRSLOtZTr+d8+U4YJ7jCWvx9609ItOwriGVXsI4xEzTAYoxa
R581LYYJMj1CnTl06hsGPSn9etDfrQxHwrjpQkYssq9vZQIp6qdrklCQ8uqIReYp
7nFnLR5kK3JSxiWglH3ZixV71+UsaYM1kFyOKGh50Bv/HOEYV7mrtaXDRN3trIwO
adVoFKTh95DpxJru9tDyvOv/2opPnwlPBrsQEWKDDEqG/NpfgTLjmx91UKOmkLgk
QDUGryUQlie8EzcasL23jjnJq7qD8wySOQfAZ9hF9zwv74+RpFfIEaElQGPOtTbx
1JJco0fPoVJWRpRFKYkA98xcCNMQayJ70HrFWeenMYSaB9ucnHlic4Kn5GyGdWBH
rUEdS1Pq1fD46FFOeDAAvEXOFh/Br0yRrIpLkJrqICjTGfA24YlCGKsIU9/84nfG
zHRuYmUGFtUrJOmLNqAi0y+UOJT0OJKBE9tcKSsAVJMrj7qkfxeRdnMnpkfl3zq1
+MEFLMuEVdAW31xheXa0UkX+okQXPsvQohMgnd1EIEUGNS1I+aSmiyy6NLPUQwMI
mCdGX6F8+rOZ/lpQEsZX
=WOMI
-----END PGP SIGNATURE-----

--jfKKxsauufOwfRcLkA7E0QNtlnat6EhHh--

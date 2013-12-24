Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab3LXQju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 11:39:50 -0500
Received: from imp02.mtu.ru ([62.5.255.19]:43338 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab3LXQjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 11:39:48 -0500
X-Spam-Flag: NO
Message-ID: <52B9B8C9.3090406@pavlinux.ru>
Date: Tue, 24 Dec 2013 20:39:37 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131118 Thunderbird/17.0.11
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.6-rt9
References: <20131223225017.GA8623@linutronix.de> <1387900067.5490.33.camel@marge.simpson.net>
In-Reply-To: <1387900067.5490.33.camel@marge.simpson.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="SS26MdTXqJ5C3lLxiHsIh3g6EacMso67w"
X-DCC-STREAM-Metrics: ss27-so03.mtu.ru 10003; Body=7 Fuz1=7 Fuz2=7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SS26MdTXqJ5C3lLxiHsIh3g6EacMso67w
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

24.12.2013 19:47, Mike Galbraith =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Mon, 2013-12-23 at 23:50 +0100, Sebastian Andrzej Siewior wrote:=20

> crash> bt
> PID: 508    TASK: ffff8802739ba340  CPU: 16  COMMAND: "ksoftirqd/16"

YES!!! And ARM code broke :)



--=20

                                                         Pavel.


--SS26MdTXqJ5C3lLxiHsIh3g6EacMso67w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCgAGBQJSubjJAAoJEPtok08Dny2h9r0QAK+oKfyG4UMguJLu1gwDRXdX
mJjmVcvHL1blxjrFbEyb7wKOhHdpZEziq+FIT+M7YGPOKcLSrfOecKkXA+/Q3sKx
e678CdkgYzxyZE3njP9NGU5ss++srftbCWjtetGiIcSVD9Hx+gyIbbpH9OeeQTBR
EHwyPm4Mdod5q3F/nrh4+O0Ujzn3wJ/es8Yu6+d8bwSx4ifpEQXYTBc68W8TOJ7R
+ZqGRvyyWFqVpvckMKfU3UYy79DmS1To2AfaUV34BGAJikyNRNkl8kA512tHpJCD
7Bn45JnWY+Yk/QDkV8dRO24dpzsS+HpIxo1FKOxh4J/rjKAI2iAoQGxiU0lTYu5u
BHxYBHQsiQEX/3gWZ4gWHn+2OPz3T1NE4JIGk6qEE+vyHHFETbJ8zjyY0d6OEr36
7/n71Iu07yBxsjGiGOhvQPEMjE2JmRWYaAm+1iRXd1IE+mnhjuyVa/hsU29EDNxS
sRgCJ606V1czpvS/1qKK/9cK4kOsdkB0DxNj125exoHy+xNzkY3ISP/lA547i4iQ
T6C9GP9oo+KJLY0INeMoGpidN2yvTt01CNuBZqyQt0/+Xi0mFg2GAGnvQEaGAwPG
c8V8AyDQCButDt6VWZKhGzX/Q9ghIgX0d1IrKwUysvgNB8t2oB7IFdkEMCrwWmzq
UqJINm5aSiNjYZeLZZgW
=3Xn4
-----END PGP SIGNATURE-----

--SS26MdTXqJ5C3lLxiHsIh3g6EacMso67w--

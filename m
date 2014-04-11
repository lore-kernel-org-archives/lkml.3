Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbaDKHQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 03:16:16 -0400
Received: from ladon.golden-gryphon.com ([50.112.111.207]:51464 "EHLO
	ladon.golden-gryphon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbaDKHQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 03:16:13 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2014 03:16:13 EDT
From: Manoj Srivastava <srivasta@acm.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Jason Cooper <jason@lakedaemon.net>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: fakeroot make-kpkg is broken in 3.14
Organization: The Debian Project
References: <CAMEtUuyLOFOfJDOjsx8+L35_ULnmY+oBCMc5nqerncXe=FGH_w@mail.gmail.com>
	<20140404152746.GC28334@titan.lakedaemon.net>
	<CAMEtUuwv_9PmmJrn_oaY031O+E4gNmOWQ0f_iwPJg0MxfjQ55Q@mail.gmail.com>
User-Agent: Microsoft Gnus Express, Build 5.13001 (0.10)
Face: iVBORw0KGgoAAAANSUhEUgAAACYAAAAwCAMAAABKbPgaAAAAM1BMVEUAAADIjH/0rp1KPz79
	0b+ic2nlpJc2Ly2AY17VlYb4uqi2gHQXFBN2WVXgno5iT02Xa2Nx+jaIAAACVElEQVQ4jeWU23bj
	IAxFLUAggQX6/6+dI9LGTpo+9mlYiXNhc3TnOP50naZE0tqvgEk+soutnNfQ8yPTWMTENhNrjI+Y
	+N7POVt8tAzpn2vJlsmttbyfrdkP7hx5iezteGzsbOts7xT+tC1mcG+LtRP2X/16bEQExuyx1uZW
	vscrAWUT8aE0aDBeBuw8nS5u4WgWyDCllOZUBeyWgbWbGrBsTDpTx0qpphlcYPcgJLvBXFClPMg5
	6WH2JidLIAaDF5aAed7uPTH4bjw0bZvfajp2tHc1F+cBm+Vr9YomGSwNhbmcczYEWUu5MBpYvCLV
	F+ZIKwQfYB+CBXnIRQFvIRhK6l96PemsFLEPFxi+MPxiTYH0Ave1InPsIYes3NJb42ytBSmmysyj
	lIQYHJm6Im1WbQ0kWMesKFRFPKTDzJ3GhWUn2KWKEkWlKthoACLm2eWJQQh2qKbAUgQxa+8TVjn1
	aySm8656ookCfCc5TRzvnZ6YOu3NpHg+uR5YuRkNF/b5IHq5Y7Ve6c2+sR4hqIZ3+5DCt3ukh8Eo
	vFIXVJxqfMdbkd/BF3YaQkB/2RIUHPMS7RLVAHefrYzWZVQ/ei4peBsROFLi90ltQyvF5I05t4Zs
	L4C9DODJ2AZCUf8UitGjCIdfx15QQkfZibTOGT3edxns5fY6F2rstKcTwiiaJnQwvYkdzTlaTqNH
	IkSmGdLrON45tGsMNDoSYr4bxH5emHEFaoFjKBahHXFXfLx9cR9p6ejJXihuxPz57gWHZkWovbPl
	9gsU8eImtBi++3D+f+sfT/Mg79fyEz8AAAAASUVORK5CYII=
X-URL: http://www.debian.org/
Mail-Copies-To: nobody
X-Hashcash: 1:25:140411:grant.likely@linaro.org::Q7aHfiZiVZPxnvBf:00000000000000000000000000000000000003UPUZ
X-Hashcash: 1:25:140411:jason@lakedaemon.net::/oD5lQqYgWnaGvjo:00000000000000000000000000000000000000003slxE
X-Hashcash: 1:25:140411:linux-kernel@vger.kernel.org::FwMogWTWlk5Cbhr4:0000000000000000000000000000000059mRq
X-Hashcash: 1:25:140411:ast@plumgrid.com::zSzzsyiWa7lc+hXj:6zR1D
Date: Thu, 10 Apr 2014 23:52:06 -0700
In-Reply-To: <CAMEtUuwv_9PmmJrn_oaY031O+E4gNmOWQ0f_iwPJg0MxfjQ55Q@mail.gmail.com>
	(Alexei Starovoitov's message of "Mon, 7 Apr 2014 17:53:29 -0700")
Message-ID: <87ob08z7c9.fsf@glaurung.internal.golden-gryphon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
X-CRM114-CacheID: sfid-20140410_235929_974535_8B5ADD60
X-Spam-Value: -0.621
X-Server-Orig: -0.621, -7.39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 07 2014, Alexei Starovoitov wrote:
> looks like it's a problem of make-kpkg itself.

        I am afraid kernel-package has long need some attention; I am
 hoping to be able to do so in the coming month.

        manoj
=2D-=20
A mind is a wonderful thing to waste.
Manoj Srivastava <srivasta@debian.org> <http://www.debian.org/~srivasta/>=
=20=20
4096R/C5779A1C E37E 5EC5 2A01 DA25 AD20  05B6 CF48 9438 C577 9A1C

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQFtBAEBCgBXBQJTR5EWUBSAAAAAABsALHNyaXZhc3RhQGdvbGRlbi1ncnlwaG9u
LmNvbUFCQTcxMDI1QTFCNUE4OEE0RTVGNjhDMjM2QkQ3MjBGNkY1NzY0NzJfMzYw
AAoJEDa9cg9vV2Rya78H/i3NkGhUHu4U6TIuQgbL8looayMCvXqsJRYNgFJjtOpX
1yzfyJmbCWHuU/3NwWlbRIq79xUyGSOh+29brQFJFsweHM5BZH7NNRYn7Z+wr39w
VbPGfXw/49ZLbWI0dkCl8wplI6CFIIN4ChcL61I48gVYed6oFwEkeUISdY3UdjHW
6lHpv4MfyZTD7R3BYJZPrSR0orPMYqnBXodqQlYxSKdqPxnZPMORa/U52s/K2DwG
v+l6d1sUlhz6zuZXBxVfHNSTKgVxL064jzLRkR2C1XLuE3rwNpci4OKODaTpQ1Zr
Jk8vIVTLYMqo6p7YdMJ3zFosq6D8yF531oCQG5tEHm8=
=eySl
-----END PGP SIGNATURE-----
--=-=-=--

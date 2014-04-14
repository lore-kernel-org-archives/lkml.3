Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaDNTmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:42:50 -0400
Received: from home.keithp.com ([63.227.221.253]:43210 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaDNTmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:42:49 -0400
From: Keith Packard <keithp@keithp.com>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>
Subject: Re: REGRESSION 3.14 i915 warning & mouse cursor vanishing
In-Reply-To: <20140414185602.GA892@falcon>
References: <20140414164010.GA1019@falcon> <867g6ryd2e.fsf@hiro.keithp.com> <20140414185602.GA892@falcon>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 14 Apr 2014 12:42:39 -0700
Message-ID: <86y4z7wvdc.fsf@hiro.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Steven Noonan <steven@uplinklabs.net> writes:

> OK, good to know. Thanks for pointing those out!

As Julien points out, this bug only affects people running master from
the X server though...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU0w6L9siGmkAAAARAQj38A/+IuiWrMEnjf7+d+y3vX6QXu7JqSmCpzx2
AmfS+eZ/sUulfRT1eK+62wrlvBNzSv4eGtwoQ3RN6vFEivydUaY/E75U19y7TeCe
/Z/f62YjyIGio7zxWNDhRVLjKgNJ7u5Pyi4PaT7YRl3wl6vDwwUu05a+AwloWJOM
nfYkXNaswRwwAp/JLLfmy7sk/VwZ9GNom90gRm/U9jRdIT2zLyf5m5NY2u89Y5ik
z+1E+pv1XktDzA8nWF0AJUs8F0WPMPIMDfuFI/q2/QkNrW2TH/1bovj5VaRZln9G
xqQzvgN+Adydtcz/yXHfZRJdGHd5j6FCPh6PE2YQ4y+1Yy9XOMR4e70D1PagOAIH
JAWl0Wlns7608gmXU7dgv9AhhjK0izLn5MrBnwsYhPJ46fU5xho6Jr8fhnb/Q0qJ
RFr2C8Ub/Z0rZGTltCS9j6RnM9SHfmTImVeHjn/701JI1LFN7opAMOSgbp46xG25
o1iSAPdCbvMu7XY4XQ8+0fe0WjlCzVfhJIoYt4yRrGNl4QeUjKAy0jpGW93bd3K1
A7l+EpIh3Mivekk22XdLRhukAQ2F3GmgzWxE0k0AotNm4P0Wt0f7HKp2LuP7vCi4
DMBvbDBGQrkY+nnPKIN3L0flqgV3LoiLjX7hRnd9ZKo9+bLsucRyqaMeyCxB2eAn
VzDFcd+On/o=
=9c7u
-----END PGP SIGNATURE-----
--=-=-=--

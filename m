Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaBKD4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 22:56:13 -0500
Received: from ozlabs.org ([203.10.76.45]:35875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbaBKD4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 22:56:12 -0500
Date: Tue, 11 Feb 2014 14:56:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre TORGUE <alexandre.torgue@st.com>
Subject: linux-next: build failure after merge of the pinctrl tree
Message-Id: <20140211145606.9e46a881c51e7aa71da43e4c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Feb_2014_14_56_06_+1100_Dx8VsTj+xSEePlZV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Feb_2014_14_56_06_+1100_Dx8VsTj+xSEePlZV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the pinctrl tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

drivers/pinctrl/pinctrl-st.c:407:18: error: 'stid127_delays' undeclared her=
e (not in a function)

Caused by commit cab6bf05bab5 ("pinctrl: st: add stid127 support").

I have used the pinctrl tree from next-20140210 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__11_Feb_2014_14_56_06_+1100_Dx8VsTj+xSEePlZV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS+Z9aAAoJEMDTa8Ir7ZwVFHgP/iu0JVw8l3S4OfmK5LJvI1s4
5SfeeWsIf87o8g/R3HELm1bhorkJQIaIaPhi+YORd+TA7fc3kCACq9zJ5Io8DQCx
/rA2BnHLKjW50eNeAIrlW4jBRNxICTt7+TbycjiW+NGIbgp7xFjZGTTCGJrQNY7S
vnz8JAF0hfoGXVxFRK6I1+mU1E/x5A0h1fa6cENPr62tCrel6WtlUfJJFltxPPxk
G5cmdmOfPOb2rjD7AR9M2kU+BJL05/QO7Ql6evRplUV+cWkbr9dmzj/NhouR1TJj
zoDaJ5he37jA65D1TVD7EJiqbsB6ez3IFc1M7wWvzTSTGMxnkp0CfmvzQO9HAVrR
9JB1YbMpUcKxqD1cFC6mpXTAGOgvhpc5QnOvb2yXgG36i+6m7Y4+1dkx/xeEXLa5
TCunZcaD32R1MipNRdXZpB6PFNjTiHwY317a1dnEv+11Es0ldqgCXFWXkaspMEoW
aOf7lwx8wb8j4GFGmXbAN3h7gDsW8+Wd5GFvIiBx1YYkd94bUdCubrHCspobW8mn
vhQ6ZHEZx0gne/soUbt46RU9Bw+JT4mcarAdikVMl/5YyRCscA5Bx6d1Q+jm8mV+
EX0e4Y3kpLrhr9yAOnzbIc6tcsF/Un4mWKp9TMKG1vI2o4XBrd4K+IuhuRHVhMP3
xjf5nFhe56pcVA8JRQ88
=TcBI
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Feb_2014_14_56_06_+1100_Dx8VsTj+xSEePlZV--

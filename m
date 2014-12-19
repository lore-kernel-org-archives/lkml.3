Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaLSCAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:00:18 -0500
Received: from omr2.cc.vt.edu ([198.82.141.100]:38241 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaLSCAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:00:17 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: David Ahern <dsahern@gmail.com>
Cc: acme@kernel.org, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCHv v3] tools lib traceevent: Add support for IP address formats
In-Reply-To: Your message of "Thu, 18 Dec 2014 18:43:10 -0700."
             <1418953390-28891-1-git-send-email-dsahern@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1418953390-28891-1-git-send-email-dsahern@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1418954405_1952P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Dec 2014 21:00:05 -0500
Message-ID: <29144.1418954405@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1418954405_1952P
Content-Type: text/plain; charset=us-ascii

On Thu, 18 Dec 2014 18:43:10 -0700, David Ahern said:
> Adds helper for following kernel formats:
>   %pi4 print an IPv4 address with leading zeros
>   %pI4 print an IPv4 address without leading zeros
>   %pi6 print an IPv6 address without colons
>   %pI6 print an IPv6 address with colons
>   %pI6c print an IPv6 address with colons

%pI6c print an IPv6 address *in compressed form* with colons.


--==_Exmh_1418954405_1952P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVJOGpQdmEQWDXROgAQJaew//bM6yRzibPoJMWfIpZUm/sIpcbbv3Mbrb
Uo44rjjeqpGPCuNAER0V5zto7tjupyBZgW0BM7eg2KcZCyYpsfHMwvfUqO6zm7pY
7kdPtX5ca77aN8w0U0fv4uhHwjlVLZ8uIUSYB/N8PJUPwnknxPRH/GJ0Mc3zgzwp
bGCu9LETY4/oi5Eqrkmk7efBLs6tMeB5BoOnRkVT0hKohsaoCgBHyL1YOQIqGrJb
+5FYo2Brv/7MfhYCjNMXy19K16K79SKNY4zySZJTUbmIwIyhWqev87e9Vmw2Jl6w
Oa5rqTvYHKi7RRZmsUZ5t6THAkD6OjXkY3E+chSqp72rL8NUddTWWCaQrvbBGBhV
s/P23gpc3/FRvXM04Eh5+dkQB04zjSchOpemNurB9yC+RGVnT+kxDP8Ip083dt0X
iH/CzkakzjzIWB/OPrhUUFlJ/BTEO8gwdGhYuhf60ijMxm59CH7iwymh+IxXcbXQ
fthV8t0bn78+nsvxzWUbPpyRh7xlcgL04MdQG+mBUhMPUgvlrW7sOjIAFuFm2bFM
diwCNNqxpwd1kdc4xBNup+gMZeb1UVsyG1ciPIt4P7rZCHTeX9N1N+86gCf3NyG5
xAtzEs/rT88uqRaeIk63kedCgh8qOPkeFRAuEhSy80mkMqpqOhqo9Gcm8g21oC5/
cZt4bXhQAvY=
=4I5W
-----END PGP SIGNATURE-----

--==_Exmh_1418954405_1952P--

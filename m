Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbaLRVqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:46:15 -0500
Received: from omr1.cc.vt.edu ([198.82.141.52]:40114 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaLRVqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:46:14 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: David Ahern <dsahern@gmail.com>
Cc: acme@kernel.org, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tools lib traceevent: Add support for IP address formats
In-Reply-To: Your message of "Thu, 18 Dec 2014 08:10:43 -0700."
             <1418915443-45707-1-git-send-email-dsahern@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1418915443-45707-1-git-send-email-dsahern@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1418939104_1952P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Dec 2014 16:45:04 -0500
Message-ID: <17321.1418939104@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1418939104_1952P
Content-Type: text/plain; charset=us-ascii

On Thu, 18 Dec 2014 08:10:43 -0700, David Ahern said:
> Adds helper for following kernel formats:
>   %pi4 print an IPv4 address with leading zeros
>   %pI4 print an IPv4 address without leading zeros
>   %pi6 print an IPv6 address without colons
>   %pI6 print an IPv6 address with colons
>   %pI6c print an IPv6 address with colons
>   %pISpc print an IP address from a sockaddr

The description for %pI6C in the changelog doesn't match the code:

> + * %pI6c  print an IPv6 address in compressed form with colons

Threw me for a loop for a while trying to figure out how pI6 and pI6c were
different, till I read the code...


--==_Exmh_1418939104_1952P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVJNK4AdmEQWDXROgAQI8lQ//TJauyYWL4b8sOqpv5JI5DdP+ZDIklXbo
zlwgE4ElDCDqhqHmDIvCMRAasARyzIWz59MKyY/uovEnJJyyJ/JjX9WhZQMC/tr9
wOP//pU7W10nl6Q8Qh8eJM8h0LPVVGRiaOoSX6OHwjFR9Gk9xc2dDlwv/MPEqxR2
C05qCte9mT0aCSz2eyTSxX1ERi4I1uE4W2FV4a3n+tGwpLqK31sR8VS91XD90fCF
TbHoXQMUOucOByifxZpqj0xBLIv8wh9eyHt2tlyJBw8Xxr5kNlziJuoXzzujUIqQ
/+hM3KxB9GWr2csLEQurrqyQtP8I49OPsye3YoT72uGTwfzJrV8tm21WKplXKTru
SdtPrze9rqGqjE/SRWb8E67H5jV8eUVQxWI5N3GjuxMAV77KQxtyz6RigY5Ac5gb
QXRbCqqdITyKr9mwE86pKZxjDukTBlaAChLrnfcxiIq4zH9lcQatkiXcUWhZzy5o
uVsS5E5V9w9TpqUiH45F6D8d2zoEH/UmA/uCT27zkTSK+DbLXSJwAeTy+4k2VRbt
4+UjtyvH7RqAaslsj1+oN3pTCmQecBtB5fxyfFe41jJTq4kmjVPAgdd4E0mWqdlS
qPn3/yA2I7dKPG7VWvIRYkgxvMPheHF10tMy7YJFm9gugaSZAp9BXGBukhpvsxdJ
YoFFOK5q93I=
=2y1T
-----END PGP SIGNATURE-----

--==_Exmh_1418939104_1952P--

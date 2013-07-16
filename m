Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab3GPAQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:16:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59245 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab3GPAP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:15:58 -0400
Date: Tue, 16 Jul 2013 10:15:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Rob Landley <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Documentation: update references to v2.6.x in
 development-process
Message-Id: <20130716101543.b458d507331c4ac32fe6686e@canb.auug.org.au>
In-Reply-To: <1373931284-26333-1-git-send-email-paul.gortmaker@windriver.com>
References: <1373931284-26333-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Jul_2013_10_15_43_+1000_IjOcvyS9RVYg=AfE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Jul_2013_10_15_43_+1000_IjOcvyS9RVYg=AfE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Good work!

On Mon, 15 Jul 2013 19:34:44 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
>  Linux-next trees are announced on the linux-kernel and linux-next mailing
>  lists when they are assembled; they can be downloaded from:
> =20
> -	http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/
> +	https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/

Maybe:

"	git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

Or as patches relative to Linus' latest -rc or releases from:

	https://www.kernel.org/pub/linux/kernel/next/

Or viewed online at:

	https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/
"

Or maybe that is a bit verbose.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__16_Jul_2013_10_15_43_+1000_IjOcvyS9RVYg=AfE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR5JCzAAoJEECxmPOUX5FE1O8QAIoNuFg8WXRAV/QZLKgFHQfR
s72LdsrzL2MqcqxppA+9Yw4maIhuGWWqB6PGp3UARuXHon0w2eT023Agy59ITbdQ
tRB8VJESQY0hLFHTLHRUNy3GsTcNpzYgy9yzWX1V538Q2krUc3IQ7gLHv6fyKAz0
ZePeSnkx/EovwYr/U7GVQkWFEGkC+FkSZTlcSNGjTCbNedqxEe9OT8XQT1Epzqk4
U+eVhmXqDo0fC/o1oA1tB7+kcrQkV+vW6Ebe8SAH5SbtY/TQ7VEoRYPrgQ1G7M/e
8GRbrJxSjxyYWGcO3Z7KF7anAB6/kNx9QAR7SbQ/Kqz4cGD5Q6dqtCSqMnJvbdjk
LMCTnX3p3JgBLSASv4J57ygRpodRK30k+qpdHBsBdLp22g2GQHjNxd/HjJbQvXEP
y52tYTDCtsfixOJ8WlhA9QZKzaQYZ2EFWtp16tpF+dDj5cu6eyZUhstwgbHyGhQb
WW/TznGa/r3Dmk2FhEnleW8KbEFxr051jHsm9tIqd15B1ILJJdAo4BplGOfM8V2K
19TcVkF6B1GihcjT9K1ztDWyKT6IcpcZxdvGF18+IfCS31kjqoNF+t+cfpO9jH2T
Oot4/j8v/aWD0f6545CVB6QaXbR7TlPllm5Obs4kkzb06Ic6KBN2mS5XgcVwePC1
HRZgHdwloVkiH0p58yY0
=WucT
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Jul_2013_10_15_43_+1000_IjOcvyS9RVYg=AfE--

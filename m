Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935892Ab3DHUAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:00:24 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:41447 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935846Ab3DHUAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:00:23 -0400
X-Auth-Info: WgkbK1TmQPyCpYPlzA6BCXLJoVq1iZBK0RMWRDP8uKQ=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Junio C Hamano <gitster@pobox.com>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v1.8.1.6
References: <7vehel3ng6.fsf@alter.siamese.dyndns.org>
X-Yow: Hey, LOOK!!  A pair of SIZE 9 CAPRI PANTS!!  They probably belong to
 SAMMY DAVIS, JR.!!
Date: Mon, 08 Apr 2013 22:00:13 +0200
In-Reply-To: <7vehel3ng6.fsf@alter.siamese.dyndns.org> (Junio C. Hamano's
	message of "Sun, 07 Apr 2013 16:55:53 -0700")
Message-ID: <m2ip3woks2.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

> A maintenance release Git v1.8.1.6 is now available at the
> usual places.
>
> The release tarballs are found at:
>
>     http://code.google.com/p/git-core/downloads/list

The description on the download page
<http://code.google.com/p/git-core/downloads/detail?name=git-1.8.2.1.tar.gz>
is garbled:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
ad9f833e509ba31c83efe336fd3599e89a39394b  git-1.8.2.1.tar.gz
bf4abd0e020d24ee47c64760e9fe4372c596d354  git-htmldocs-1.8.2.1.tar.gz
6c40ace4682188d0c01b1091b37276151bc77a74  git-manpages-1.8.2.1.tar.gz-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJRYfrbAAoJELC16IaWr+bLH0EQANm9GihAS+37VGysxpSvkKuL
NEWDpmesCH0IYIxeiw8ECXMhxwWGfhSH3lRJkSIu4SxIZINsdMFRKxweYfHDbs6M
3pdAwocZnUkL7jVtxjUjaHI9H+/kQfimKtxp1Mdell4kKkybc6XTOsn+ibEd3sFp
CULKEg0fnS/B8g+RZALhWjyS5iPXChfQF0Vn5xoqTPLSj06Nqxq0uyF7FX9x/9ti
y3j8m8vE9tk/T1Q9P7o3Az2hV5mnC0VhRrB0wcBHWHK2N1H2v5RKjyUaVteVY1LL
iJjEJziJhoBYQo4ptnGyQo9NaL/FV9DvuPYKoa/qBKTxilYBFI5ZTrnTpZzzsi47
l18fZtDUN86voMIFPQzO7m3c5JPDbsJn0oUiwqKWLEIvufBaLAgNFJRi5xwQJQ0P
FkfDGFKutfnVFnfBffrP4YVemZX5hN9TdH7NfPfHJUKuxUn3sDEGkuvbqJ1EZj7r
bkuFF7S8JTsRxJ92hdctDVAjCA9fW23t8smBmmQ1PQka+wzawNeV/wAmMJ9Um51h
8ut8jnfWbZNsJfwYnpo3AB6iqT/gRZ5fTjhAwXcr9da/FG05OWk9RpkwI3vbTvw+
7YDSrBDgS59rnhXKjJrVQ6vMsKttvt3LPl7Cr2uMjxAtZuvUCnjLxfSbF8axE5SU
KtGfnAbYvCQYBfIKKSwS
=kNrb
-----END PGP SIGNATURE-----

Note the missing newline before "-----BEGIN PGP SIGNATURE-----".

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

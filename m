Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab3I3Otr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:49:47 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:46403 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3I3Otq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:49:46 -0400
Message-ID: <52498F83.7040702@gmail.com>
Date: Mon, 30 Sep 2013 22:49:39 +0800
From: Lennox Wu <lennox.wu@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [git pull] Score: Fix compiling errors and update the information
 of maintainers (Fixed format)
References: <52498EA2.2080207@gmail.com>
In-Reply-To: <52498EA2.2080207@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="utuoQLtJen6CLXSfroplavwVJecG8w1o5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--utuoQLtJen6CLXSfroplavwVJecG8w1o5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Sorry, please ignor the mail. Some thing wrong in my mail client. The
mail includes wrong format.

Lennox
=E6=96=BC 2013/9/30 =E4=B8=8B=E5=8D=88 10:45, Lennox Wu =E6=8F=90=E5=88=B0=
:
> Hi Linus,
> Please pull these updates for S+core architecture. These updates includ=
e
> updating information of maintainers, fix some trivial errors, and add
> a necessary function for supporting ipv6. We fix the format of the link=

> and use a tag.
>
> The following changes since commit 22356f447ceb8d97a4885792e7d9e4607f71=
2e1b
>
> mm: Place preemption point in do_mlockall() loop (2013-9-24 18:29:11 -0=
700)
>
> are available in the git repository at:
>
> git://github.com/sctscore/official-linux.git
> <https://github.com/sctscore/official-linux.git>tags/for-linus-20130929=

>
> For you to fetch changes up to ed38665eb50ef7ad530f9b2db531a09b8520ed32=

>
> Score: Update the information of Score maintaners (2013-9-26 01:41:22 +=
0800)
>
>
> Thanks for your patience.
>
> Best,
> Lennox Wu
>
> -----------------------------------------------
> Summary these commits:
> 1. Fix some trivial errors for successfully compiling the latest
> version Linux kernel.
> 2. Provide necessary function for support IPV6.
> 3. Update the information of maintainers.
>
> Signed-off-by: Lennox Wu <lennox.wu@gmail.com <mailto:lennox.wu@gmail.c=
om>>
>
> ------------------------------------------------
>  MAINTAINERS                       |    4 +-
>  arch/score/Kconfig                |    4 ++
>  arch/score/Makefile               |    4 +-
>  arch/score/include/asm/checksum.h |   93
> ++++++++++++++++++++-----------------
>  arch/score/include/asm/io.h       |    1 -
>  arch/score/include/asm/pgalloc.h  |    2 +-
>  arch/score/kernel/entry.S         |    4 +-
>  arch/score/kernel/process.c       |    4 +-
>  8 files changed, 64 insertions(+), 52 deletions(-)
>



--utuoQLtJen6CLXSfroplavwVJecG8w1o5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEVAwUBUkmPgxIBnItolwGVAQJq9ggAxJqQBw4h8deSD+NK3O9cInyVidOj2gUH
KijN9dtBdwsUNuJeHrt2ktqGLXjfvEjRyra4wcGOrqPg1mFbqonmaPGWbSZPA3W/
h/sGoYqVXjhqUySha1vMigZhQXpEfOVVsvxZGXO0mARPnwvVo4s7XfzhKSu/nvdv
dORXkJ+LTtXlFedTjfCxSdK46RFzFl+aDrwhFEuDYdPtNrOGghrXhbqVqB55xwcD
hdjNYl9a+MEkEZjQ6tmv0/n60U+D37lZW/odSvhj5DdL+22ge0kJ855y+WYlHtGM
mpUUs66V8LSaC699nBDggBN6zXvDkAlQGvb0zBApfS99XCc5m6tQWg==
=TJuO
-----END PGP SIGNATURE-----

--utuoQLtJen6CLXSfroplavwVJecG8w1o5--

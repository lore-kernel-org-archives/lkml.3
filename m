Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3EMAEg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 20:04:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51987 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3EMAEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 20:04:35 -0400
Date: Mon, 13 May 2013 10:04:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Miao <realmz6@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bob Liu <lliubbo@gmail.com>, uclinux-dist-devel@blackfin.uclinux.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [uclinux-dist-devel] [GIT PULL] Blackfin updates for 3.10
Message-Id: <20130513100423.af2a67e458a24b4e6c95fd1c@canb.auug.org.au>
In-Reply-To: <CAMk6uBk2inVj8Hu8YZ3tQ86OMh-Ub86eJmx9csrmFO+H4zq0rQ@mail.gmail.com>
References: <1368098909-919-1-git-send-email-realmz6@gmail.com>
	<CA+55aFyQVZ622dH-e+V77B6LKuYeXS+QfnYYQK77=0T82-MkAA@mail.gmail.com>
	<20130510102706.84061f044d3e59717638b731@canb.auug.org.au>
	<CAMk6uBk2inVj8Hu8YZ3tQ86OMh-Ub86eJmx9csrmFO+H4zq0rQ@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_May_2013_10_04_23_+1000_+cYODXGBYph1ZMM9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_May_2013_10_04_23_+1000_+cYODXGBYph1ZMM9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

On Fri, 10 May 2013 10:48:54 +0800 Steven Miao <realmz6@gmail.com> wrote:
>
> Yes, please update the current blackfin tree with:
>=20
>   https://github.com/realmz/blackfin-linux.git  blackfin-linus

With Bob's blessing, I have replaced the blackfin tree with:

	git://github.com/realmz/blackfin-linux.git  branch blackfin-linus

And, as Mike pointed out, having a tree on kernel.org would make life
easier for you (in getting Linus to take your pull requests).

I have you, Mike and Bob listed as the contacts.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Mon__13_May_2013_10_04_23_+1000_+cYODXGBYph1ZMM9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRkC4HAAoJEECxmPOUX5FEzM0P/2X2calwu2+yYKBl1ba0vUyz
Sae2jBJS+Qgt+h6sn3TOJ0QAIX7R6Waj/6KtJCqv+xwLn+pY/V/wqvbKHCJvsGbU
N+2BW//zHZ15r7kYExi0ljwdwiqLrs8PpdyggbjHFrAQQPCISqq16cAthTpNSDw6
ZusrCPE+DuV8gbhQY7UaW2yB3tESXvURwRUW7onrag67njMd0Em/vDfUf/B1BZln
bWI4RlcWanqOB93D91Wwb45HcDS1Hyy/kS/aZ4EgAcQxAjCy7v4qjNMshB4r9P4B
qXoZ5gpfvJ3yGNlSwTpgDPnWYGJVv+ImFqCq+MkhjSIEvXbRElRAmxQJJvDx6Gnb
1XiZ8wZu9ggUfSEEqGUDsb8fDq+92JoGQppcSVFJJqeLbjBJMbkQih9Rsa1AIjoJ
+Celv8sdpDcJYGoMKfjRu9u4QWBXMUZPY85VbqIUV4vebrYek7a4+3nA5XcUAtNq
tYFNYBL+OlgfyUmETf44/vNAvQe+WMZBc3DbJXebR0Tn4UfNbLaqae68JUCExvad
dUXZeKwdlY2gKXgSJyXgVlDDz5wAgMbC2I5ibpRD8Za3s8qqehNU/JCFXzNRK9w1
skvniEGkNyPQxipNt1eHurO3UARxSIfzCy45YxQCBcUqsThB/8tGeq3ffQbhK4EW
g0RV66C8Tciswt+gKgTD
=BR++
-----END PGP SIGNATURE-----

--Signature=_Mon__13_May_2013_10_04_23_+1000_+cYODXGBYph1ZMM9--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbaHHE3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 00:29:22 -0400
Received: from ozlabs.org ([103.22.144.67]:32946 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbaHHE3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 00:29:21 -0400
Date: Fri, 8 Aug 2014 14:29:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mollie Wu <mollie.wu@linaro.org>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>,
        Andy Green <andy.green@linaro.org>
Subject: Re: Request to include Mailbox tree in linux-next
Message-ID: <20140808142912.7bf68229@canb.auug.org.au>
In-Reply-To: <CAJe_ZhdZTSs+Ns4u7bMXwbLHYTnE-5XEE8uev4zXbXrCP52bSg@mail.gmail.com>
References: <CAJe_ZhdZTSs+Ns4u7bMXwbLHYTnE-5XEE8uev4zXbXrCP52bSg@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/JESdqHwuc3kKeYJg1GgLtk8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/JESdqHwuc3kKeYJg1GgLtk8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jassi,

On Wed, 6 Aug 2014 12:25:49 +0530 Jassi Brar <jaswinder.singh@linaro.org> w=
rote:
>
>  The framework for Mailbox has undergone 10 revisions over the last
> one year, which has garnered support in the form of 'Reviewed-by' and
> 'looks good enough to be merged in this window' from people in the CC
> list.
>=20
>   Could you please add it to linux-next?
> Tree:       git://git.linaro.org/landing-teams/working/fujitsu/integratio=
n.git
> Branch:   mailbox-for-3.17
> Contact:  Jassi Brar <jaswinder.singh@linaro.org>

This is really late for v3.17.  The purpose of linux-next is to
discover interactions between trees before they are pulled into Linus'
tree and to do some cross architecture build checking.  Adding a tree
during the merge window is not very helpful to that.

However if this is really going to be merged by Linus before v3.17-rc1,
I will add it on Monday, OK?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/JESdqHwuc3kKeYJg1GgLtk8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT5FIdAAoJEMDTa8Ir7ZwVQroP/A64p9s55hLclpcir7HIihyR
imqsFhLVBQNqok38P4ZGL8upj/NydMJQUSpZ2mjKNdoEqt+n7HuYydgxoSmkl8+T
hY1iNWxvaKlAv15YdfW6/BrbsdjFlefRlAbv+5JPURldDTwIVY9ymN04dWOTrb4h
n/HTskmTQjyogpT5wOC+xt09b4YL2pi1aB2vFRzfzMaiuoAwqTJDZMLUDcqiXGIz
PPP9ZGAp/37qiAozGkvJ0Lc9F2zQErAUfGB5hXw0jP7gb5BELXVa0XlSQrvkAl8D
JorihkBtErKJ9EskfpwFgS5tTf1yObnjBTFJ0BtRMJX209Bc0aAMirURd4Yqy0oW
t72kPChdq9Ja5U17dIzNwY6yVAQC+5PYnsH1h5pAihMX5/FZEjGgXFR/NST/hgl6
quBiew0tcX4ZvOOHYWhYTtjMJySOK9xJ4kcb6a1ZV/A3vPLNpKpz+TO6rYtpQU81
EXbJ6hQ9dwRnZ7hfagUl9/1T2ibvKTc2wZ0SQCDgApuOfrQqKIw6zeV6J7kEcvJA
79js0j3HsxY8+NzXZIHVxHVf7+dTRPVPltz734qz/tyNFSW0woiHGnQsNA/DTC05
PWhOrF57W3eT7Ke4QUp1l729ihHsJQdyVdCJU0Tg1Z99xI++IF88qFN8d/4nZ/Iy
yJQtMVFqEpuMONtms28P
=nWpD
-----END PGP SIGNATURE-----

--Sig_/JESdqHwuc3kKeYJg1GgLtk8--

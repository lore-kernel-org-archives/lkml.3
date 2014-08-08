Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbaHHDZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 23:25:20 -0400
Received: from ozlabs.org ([103.22.144.67]:53567 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbaHHDZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 23:25:17 -0400
Date: Fri, 8 Aug 2014 13:25:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sonny Rao <sonnyrao@chromium.org>
Subject: Re: linux-next: build failure after merge of the mmc-uh tree
Message-ID: <20140808132510.68e8ae66@canb.auug.org.au>
In-Reply-To: <20140728144608.7d9ac736@canb.auug.org.au>
References: <20140728144608.7d9ac736@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/wLfKbuap5S4o2FSqr1GOM+n"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wLfKbuap5S4o2FSqr1GOM+n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 28 Jul 2014 14:46:08 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the mmc-uh tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
>=20
> drivers/mmc/host/dw_mmc.c: In function 'dw_mci_reset':
> drivers/mmc/host/dw_mmc.c:2262:3: error: implicit declaration of function=
 'dw_mci_idmac_reset' [-Werror=3Dimplicit-function-declaration]
>    dw_mci_idmac_reset(host);
>    ^
>=20
> Caused by commit 25f7dadbd982 ("mmc: dw_mmc: change to use recommended
> reset procedure").
>=20
> I have used the mmc-uh tree from next-20140725 for today.

Ping.  We are nearly half way through the merge window and there has
been a patch posted for this, but the tree is still broken ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/wLfKbuap5S4o2FSqr1GOM+n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT5EMbAAoJEMDTa8Ir7ZwVjAkP/2LxCLfCqtUGNNZVUyrmk9zZ
/N9y/DCEdPxrjMhOIkNmLRQiitJUADKozrSowDT34/qgTkaGknkvzzNm8lVhztzN
kBvs3ffpXPh3KL3lPbjg08w6M2Q9dzFZBkZdwGMItRC28/IJcLa9KfoEkeQR+IPL
dBo2IHIpNyaw5OVB5HBR8r8Q2mOpWqnky/wkPOTTQSRV6L8EMSYLQnMjF9gGZ49b
RhzT6K4h10mQ5ku/foUAX/VeLbs6SVUdzR+kQ240yof/XYaO1mov7Vm4z554rj3Y
MW6FSYuqf8s7btGxdHEDaX44m6dkvWONEub3TOvQU5BxiqyB9a3VVFS8In0ARGar
iDDT3CG4f0pkxZFyGYmLXCku9rmDI8hGcEwNZe5apUWgisYoDURNL8nTxNrSe1kv
jM38eaIxS75APO0MfglYzcTcWVqy0t/S4dzV3haSgueMuy9GUd1RwfH4tDFqeJw0
uFojKmrJE9uPkYK/rcxXmm/hg2lvbjfMEbZ6pu1Hb/b0QExW119NAdK6Dc0gHu0t
zjCg31f2J/zmKzSMcynMJ+6ROSFlP1uyO8EwI+dk6BIUQ85UtN9/sKjMihgr79nM
TSyOh90HS8QWQn03xR2KF6W3KQwCNi5bXiVUelqbvzj5cur5W7sTernF85/eyIip
rW/k7Be2YqpBxbC6PLTH
=uywk
-----END PGP SIGNATURE-----

--Sig_/wLfKbuap5S4o2FSqr1GOM+n--

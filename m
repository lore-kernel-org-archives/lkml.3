Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293AbaLJUv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:51:58 -0500
Received: from ozlabs.org ([103.22.144.67]:43096 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932116AbaLJUv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:51:56 -0500
Date: Thu, 11 Dec 2014 07:51:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: Tree for Dec 10
Message-ID: <20141211075142.5fe2993a@canb.auug.org.au>
In-Reply-To: <20141210113014.GB10836@hudson.localdomain>
References: <20141210204822.3359b7ef@canb.auug.org.au>
	<20141210113014.GB10836@hudson.localdomain>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/2njhpQ2CAs.yaQcDirTDEps"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2njhpQ2CAs.yaQcDirTDEps
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jeremiah,

On Wed, 10 Dec 2014 03:30:14 -0800 Jeremiah Mahler <jmmahler@gmail.com> wro=
te:
>
> Just a FYI.
>=20
> As of -next 20141210 commit d32394fae95741d733b174ec1446f27765f80233,
> which caused a suspend hang bug [1], is still in the tree.  Greg created
> a revert patch for it in driver-core [2] but I am not sure if this will
> make its way to -next.
>=20
>   [1]: https://lkml.org/lkml/2014/12/3/215
>=20
>   [2]: https://git.kernel.org/cgit/linux/kernel/git/gregkh/driver-core.gi=
t/commit/?h=3Ddriver-core-testing&id=3Df1c488a78d9f1a22cdb15648c15e70fd82ed=
229a

Unfortunately, I can't control how often maintainers update the
versions of their trees that are included in linux-next :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/2njhpQ2CAs.yaQcDirTDEps
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUiLJqAAoJEMDTa8Ir7ZwVNtEP/3sFs2d6/uCJGLfGf+mcsv7q
nkNZ7nEPgVxGYUn6HEgGf6ZGoFTw9xJ+965xnqBWNftGmEXOZKtM0vbg/oJsOdjs
zz7x8ySwvXIGzY7TV2GzYYMnBexI7P7CkSNb2i0uyzUA/G5RqRh8/dlXyh8CRo8f
3tUffmB8HFo3Dt0BIGAPXUT+op1MOm8QtfSiByNNm/IpYNLS9ncICsuQLle/QoY6
hTJ1Au99R5Wn+u9YDTlRFM1aSiIr0K18xInmh0TP84ktVQ6WaW7ZBr+183caYjwO
gWgF1mdkZITVWxTBdiGtEYK6XhUjyUvi0U25oHTPxN26XMCWndl8ODvb2qDcELkj
JFcVc4pKcRnpG5vaiq3gCTgmQ1v8WaxtRfC64KfbPejpgywB16Izrv75J4oR+Ze+
02sEaSoBXNawlvyfsyPVkPHCZ/92LdpYsPtHJlucG+NIcLH10KCQTuA+rabTaAz/
0Lx/tFOEsEfs630cxW0ZFgoi2tEf4IHCWwJzVhMDP6YSZvacydxGq6051SW+cIcs
azhpgnBM2x9pkZUvj1/nsSSriM3YJobESXXMcspPvk1qgJor3qeXJ35fXgX1oEvb
rgvDesQh47v5WCKllEOwcst3Hf7tL3stRODYaU2026X6YBUpdMCUSy02BCljAMiF
rxq96fYkBsiPns/Y4LW4
=uf0Y
-----END PGP SIGNATURE-----

--Sig_/2njhpQ2CAs.yaQcDirTDEps--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaFDBHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 21:07:40 -0400
Received: from ozlabs.org ([103.22.144.67]:44398 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbaFDBHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 21:07:39 -0400
Date: Wed, 4 Jun 2014 11:07:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: failed to fetch the aio tree
Message-ID: <20140604110731.11226e7b@canb.auug.org.au>
In-Reply-To: <20140604004300.GM5097@kvack.org>
References: <20140604090846.3b4fd54c@canb.auug.org.au>
	<20140604004300.GM5097@kvack.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/rH.__3P2mhF/C+F8o0PrtX9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rH.__3P2mhF/C+F8o0PrtX9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ben,

On Tue, 3 Jun 2014 20:43:00 -0400 Benjamin LaHaise <bcrl@kvack.org> wrote:
>
> On Wed, Jun 04, 2014 at 09:08:46AM +1000, Stephen Rothwell wrote:
> >=20
> > Fetching the aio tree (git://git.kvack.org/~bcrl/aio-next.git#master)
> > for the past 3 days has produced this error:
> >=20
> > fatal: unable to connect to git.kvack.org:
> > git.kvack.org[0: 205.233.56.16]: errno=3DConnection refused
>=20
> Whoops, it looks like the system upgrade that took place on the weekend=20
> didn't managed to restart git-daemon.  That should be fixed now.  Thanks=
=20
> for the report.

Yep, all good.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/rH.__3P2mhF/C+F8o0PrtX9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTjnFZAAoJEMDTa8Ir7ZwVfvMQAIP87pCOjR/Ol5al2bJzCu9y
slAjnk1cdQXUvVLivf7HBBFjMp3PPi60K+L0KOKtCCS0A8xMc9jp4jikKDLK9Of/
cWb4XNGkhYn+3NIptTuaeRmZLGylVwcD2EZnS4RIt9+vtT9JARDQ/u51BTlJbthS
6TnWAoer2p+45pLbCC2RCWpuukFzLgHWfApkFhE/9FSd21nsgoft2W4OA0sU3c9S
KQuqRu+x1QskbZYekfFtnvcpt/dJo5dT28Dii4Ce8d5n6RvL5YzUAn2qnx7LAPiQ
R2EQcL56O4Co5cv4Pu/3xgeM08nbg/jlcHfAEkKgMfZA6oLRIspw/mSZoFxE8nwa
pJref/l6rv2/eEY3upS/6wc6VKTDPsHQ+ecYQ8dvTtt2KVUfgxvQeBGxOyaouVuM
9tkhDw4vYUcWubcmR1izpdD02ltvV3Euw0ZP4bl/eUAuo38PpsLAAA8xsa614yxU
/eyTCmKkw54tG1XwckMkTR0uy2Bwa7N224gQH+dHBVsRn+oLiIZP9hTSt7IuJl/V
dZujjq9oVkP83Zi3G6wMXYFzjEmAHEFoaVns9oyJzdu9jUf+G/7yLRIOQAIZyuTu
hwVzFIQjzU8/+M1gKfS1/zEOwWebn1IaBCUxTRVmayMfpXP7D4666qGG+Ku+jVz7
MXiAbiu9yYwBn2Lq4vyr
=OnHD
-----END PGP SIGNATURE-----

--Sig_/rH.__3P2mhF/C+F8o0PrtX9--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaHAFVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 01:21:53 -0400
Received: from ozlabs.org ([103.22.144.67]:53793 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaHAFVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 01:21:51 -0400
Date: Fri, 1 Aug 2014 15:21:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoffer Dall <cdall@cs.columbia.edu>
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <christofferdall@christofferdall.dk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: linux-next: manual merge of the kvm-arm tree with Linus' tree
Message-ID: <20140801152141.15d028c1@canb.auug.org.au>
In-Reply-To: <20140731142347.GB589@cbox>
References: <20140731163004.474501fb@canb.auug.org.au>
	<CAEDV+gJ1oSPzgZMO=kdFDNPnzy-EOHGuLxHqTB8KO6d_8yPrxQ@mail.gmail.com>
	<87mwbpiv0z.fsf@approximate.cambridge.arm.com>
	<20140731142347.GB589@cbox>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/=g8B=AAE41pOt58oODPQxwr"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=g8B=AAE41pOt58oODPQxwr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christoffer,

On Thu, 31 Jul 2014 16:23:47 +0200 Christoffer Dall <cdall@cs.columbia.edu>=
 wrote:
>
> Stephen, did you pick up the resolution provided by Marc for the gicv2
> fix patch so that it applies to tomorrow's next/kvmarm merge?

Yes, I have.  You will need to produce the same for Linus eventually,
or do the merge yourself as I suggested.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/=g8B=AAE41pOt58oODPQxwr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT2yPsAAoJEMDTa8Ir7ZwVQ30P/3eD/3MZBY7NTzcFVRSy8knr
JVta4BccjTrO2yOgsyPvNjnLA1DjuMiQCW3C9KyaP2AVbMl+TLBQ+t+25gP0qiSZ
B+pESo3YGJP8S4xNY8sg32f9DZWqBViOmmX+xTDSrXRKuEoUjouNtRZWd8uGVz8a
2R0KhhQqt1vhhQXokvZ7scWATXUaK+7jH3Ajxnsa4nhawdKKKRRlIbGvKju9/KEM
xhV2R+wqCblDaiRmiai2bOaZpoPf3+BKvg3Pv4g6d1YTHQN+hxper21GBRYlJpnd
VUqqvub7hG+gQvo40JoiXbT3JZriSEeaYwDU525196vq5H3uUe1eiiLoocQnqV8L
2DUCC+2iK149cu0fnMST8y+ZuVBPLaYRABCSa1X1/P+u8N7+3KaGEEbD6/4u4r+k
O8IkG2x2IzgZdxYAIth3c1Cz3tVEBWgV4usaNQdbCfqhdfH+9IvfVLolR/CZK24D
CWveQKMrjcY8v75xTZPS6Daw0IL61tnGlVAsj5TwLCntMaXLDaBiOZmAfHc+J3re
wWFyPnHd5o8GDSy0gAc8rPWr2c/spyg8VgIMWMtrhxMz7+WkDultyWw4V5e9Yabr
YAm9IFEUJldtYw6zG24WWa80AA5Pos9SlfMN+Lx0vpnLPbenwCdvOAXhGM9T7GIv
c+EMdVtuYZN820l0OSqd
=XOml
-----END PGP SIGNATURE-----

--Sig_/=g8B=AAE41pOt58oODPQxwr--

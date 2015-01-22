Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbbAVXFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 18:05:36 -0500
Received: from ozlabs.org ([103.22.144.67]:53048 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbbAVXFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 18:05:33 -0500
Date: Fri, 23 Jan 2015 10:05:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>, Wei Huang <wei@redhat.com>
Subject: Re: linux-next: manual merge of the kvm-arm tree with the arm64
 tree
Message-ID: <20150123100527.5d1ce089@canb.auug.org.au>
In-Reply-To: <20150122102920.GA12911@leverpostej>
References: <20150122160704.5ad5aeb9@canb.auug.org.au>
	<87r3unfb9x.fsf@approximate.cambridge.arm.com>
	<20150122102920.GA12911@leverpostej>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/CrJyI9rpB+ZdN400eLvJu8o"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CrJyI9rpB+ZdN400eLvJu8o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Thu, 22 Jan 2015 10:29:20 +0000 Mark Rutland <mark.rutland@arm.com> wrot=
e:
>
> On Thu, Jan 22, 2015 at 08:51:54AM +0000, Marc Zyngier wrote:
> > On Thu, Jan 22 2015 at  5:07:04 am GMT, Stephen Rothwell <sfr@canb.auug=
.org.au> wrote:
> >=20
> > > Today's linux-next merge of the kvm-arm tree got a conflict in
> > > arch/arm64/include/asm/kvm_arm.h between commit 6e53031ed840 ("arm64:
> > > kvm: remove ESR_EL2_* macros") from the arm64 tree and commit
> > > 0d97f8848104 ("arm/arm64: KVM: add tracing support for arm64 exit
> > > handler") from the kvm-arm tree.
> > >
> > > I fixed it up (see below, but this probably requires more work) and c=
an
> > > carry the fix as necessary (no action is required).
> >=20
> > Thanks for dealing with this. I think the following patch should be
> > applied on top of your resolution, making the new macro part of the
> > asm/esr.h file.
> >=20
> > Mark, Wei: does it match your expectations?
>=20
> The below patch looks fine to me.
>=20
> I suspected we mighh see something like this, so I kept my
> arm64/common-esr-macros branch [1] stable. Catalin merged this into the
> arm64 for-next/core branch.
>=20
> I guess the easiest way to solve the conflict would be if the kvm-arm
> tree also merged that and fixed the fallout there?

Yes, that would be a good resolution.  In the mean time, I will apply
the merge fix patch to my tree (I will remove it when the above
resolution is done).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/CrJyI9rpB+ZdN400eLvJu8o
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUwYI7AAoJEMDTa8Ir7ZwVlkEP/1kDMq0YOZE693rQUemP+KEv
/pngfHgZPtXLfMyfmDgsiTCyoY3ZFwtx78+8ssZdEdgYg/Oq1sezCApX1c81LUXS
gpyj/MxKxDwJw/GojPwcKuikwjNP25pYUoYj5WeuhCdLIFlRRP8prCjaZovuoJvW
ZgHa6BYTEPJH6p3Snq6FL22KCd5kYnfsKdTNddYJMZvzv6Tw8l9raS3f0ZTHhShq
BUxLsoMenQbCNNqtfIKqt68IRqo9ww82/wwyMqbqoGFDCVnWmL40sg7OsKQpGdf6
rw29vVjGzKqUURvARYQd8uhNeTDRqW4rpRfnuHNQ5SkPskyOCOyjLdVM3fP+WKq9
Fy9O7GPczx9X3sxeIjgt3CskmOglz01QlJw8ZJyq2Tl3Uz38DW0jQ1XIHj9tambE
+L5AjU+QSRJGq9eC5PoXk7N39b2AgayLXBBon1DQSfrtrTqbu2+ofjBiswNQGTEM
HB5J35R6oMqOS8Sp3DO8xHn5T+L1KI0pgjDPbQbBCFBalicbgGNwjATTd56EalhR
Gin3rmc18Z24O/oscXCSuHy/IHVyEHBUQO6xd/O14hMhL3PfKMVB9outmFL3+Yuq
wzDLSYXp4vrj1ZIEISjfEQAJS4SrB76yFBQep9Q38IsVTlVXnL0IWSo1tnXmuBfI
J8mvsUXd/17W7fodl7kF
=YgFc
-----END PGP SIGNATURE-----

--Sig_/CrJyI9rpB+ZdN400eLvJu8o--

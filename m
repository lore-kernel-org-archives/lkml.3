Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab3GID2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 23:28:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39041 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3GID2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 23:28:07 -0400
Date: Tue, 9 Jul 2013 13:27:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Asias He <asias@redhat.com>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the vhost tree with the
 target-updates tree
Message-Id: <20130709132753.4ccecde4e20ac109ebeedc8e@canb.auug.org.au>
In-Reply-To: <1373332406.7397.161.camel@haakon3.risingtidesystems.com>
References: <20130708134721.8ac2d67125b60c745d46006f@canb.auug.org.au>
	<1373332406.7397.161.camel@haakon3.risingtidesystems.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__9_Jul_2013_13_27_53_+1000_tr/YG0rulSySpz.N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jul_2013_13_27_53_+1000_tr/YG0rulSySpz.N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

On Mon, 08 Jul 2013 18:13:26 -0700 "Nicholas A. Bellinger" <nab@linux-iscsi=
.org> wrote:
>
> On Mon, 2013-07-08 at 13:47 +1000, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the vhost tree got a conflict in
> > drivers/vhost/scsi.c between commit 084ed45b3846 ("vhost/scsi: Convert =
to
> > se_cmd->cmd_kref TARGET_SCF_ACK_KREF usage") from the target-updates tr=
ee
> > and commit 3c63f66a0dcd ("vhost-scsi: Rename struct tcm_vhost_cmd *tv_c=
md
> > to *cmd") from the vhost tree.
> >=20
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
> >=20
>=20
> Can you briefly refresh my memory how the process of 'carrying the fix'
> in linux-next should work..?

That means that (assuming my fix is correct), I will continue to apply
that fix until your trees are merged into Linus' tree.  (git rerere is my
friend :-))

> So once I send a -rc1 PULL request to Linus over the next days, and MST
> sends one shortly there-after and hits a conflict, you'll include this
> patch in a separate next-fixes branch for Linus to PULL..?

No, Linus will figure it out just as I did.  If you want to give him a
hint, that 's fine.  The main intention of my "I fixed it up and can
carry the fix as necessary (no action is required)" is to just get you
guys to check that what I did was correct, and to dissuade you from
merging/rebasing/rewriting your tree(s) to eliminate the conflict.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__9_Jul_2013_13_27_53_+1000_tr/YG0rulSySpz.N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR24M+AAoJEECxmPOUX5FEaqgQAKoxrLMvDmYtNih0/+IeDNy6
W09UqAgeAJ3qluXaeYtu7+xoltHglV9v9WJv3B7N8q0TVToH5uR3vELceNWPpiva
qFpLUdzj7Y+cahQHgHvakKmNyP66JEkXUOUE/f1H2VE76nLZaI4cw2y8hECCmnSi
CjIE9GqikMFGC56TsGDW3Azi1BSYFy4NFDszTgv5tmRKK06+QS+jTYJks7IMED9s
CxigeNqOn8zLDKvdBnKiXujy1Nux+DvTNCj5Pis1+/g5fTItvRK4iet1gaJsySxC
Rwf7R7D77Q6379Z2McMs6FkOaKgrO3a5Eukjn/sw5wZ5TwHgXSv7puMmO6K9kj0F
SSCF/0gXe0gLe5bPdF5Lc2eSmfU+lzs0fR87ht2vfJNfJbagiHvb5D8k8LUqiSx4
98gwEmlB8xALIwIjg7qX6yHV9+vcWKb6r0L551X5IAV2PzmDMTe51eWIQBInUAHu
5Tk6GGaH9UffNbbARHv4cFbDTP+XWK/dYO6mZiZmsO6pmpNqFABR1TalY/zDLxFy
embCYGEfY+aH4lNoWfXWACzFRgOGPvqVdKCmxmiurOXhoY2If/pSV0JVztJZWwYI
O2PnexX13E3su01m8tpgXnibPRi+O5DKGtouCcIOJDCUutXpjLKzPs3FsNbCB1Gj
/58P6pNPnrvMeC3rXehJ
=TkU9
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jul_2013_13_27_53_+1000_tr/YG0rulSySpz.N--

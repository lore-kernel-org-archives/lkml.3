Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbaI3IqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:46:19 -0400
Received: from ozlabs.org ([103.22.144.67]:47042 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaI3IqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:46:16 -0400
Date: Tue, 30 Sep 2014 18:46:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>, Greg KH <greg@kroah.com>
Subject: linux-next: build warning after merge of the wireless-next tree
Message-ID: <20140930184607.081d38de@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Ky82CY1m2a09NxseJ6Rtz6n"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ky82CY1m2a09NxseJ6Rtz6n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless-next tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

WARNING: drivers/staging/rtl8192ee/r8192ee: 'rtl_evm_dbm_jaguar' exported t=
wice. Previous export was in drivers/net/wireless/rtlwifi/rtlwifi.ko

Introduced by commit f3a97e93814a ("rtlwifi: Finish modifying core
routines for new drivers").

I suspect that there is a staging driver that needs removing/updating?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Ky82CY1m2a09NxseJ6Rtz6n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUKm3VAAoJEMDTa8Ir7ZwVqOAP/AmhEJ6TU7HAXqKR2l0bulK/
FE5Pmm8Yz6jFw6dl56Pv88Va/lPf6OO48rP+DNEQjOfrM/Osb4FM+KsZ4EB46vLm
izAiQvOpoajXxWDaFUnjWXESj4jtAih7+OWxNFwKlTJua6PpZPkGZDGZ3CdcFeFV
862+FGuRnRAzYHaACuS18GB8+DvtO4y8wosszTW45OCq8ll5X/7Ky41kgft/7uYv
ypP7n0FelXl9Y3qDvW2kqa8iJBKynIIASEttfZLhvnkin9pWq8HhGl5b81OkIXS/
gtt6hlDdIH3F4otGsiQ2VqDGHXCT9pkx8gqTZV38qR4b9fhtQgcGuC4rvTsTkLVO
nALFza/+hrEAKzrugqaf9o/Fqq323qfQd90qwnjuI6+jDTgWiBlK5bfJa6oZyBbt
a/W1y+lzbF6BayxvMrTkLjQuwExhDwTl+wMOEh0X4qpWWZAc2bUiYPRuGbNq2+HG
FxUfxQuA5JVgsR9ztyelwLcyJWQgZ9nk5oN3SOpFgR+DFbKCJQ3utPnAWDjxCLUl
e4ObAnCt192rW4A0uFNhFtQq+HISXOa6UQDTYIzx5dTmZpggCsnfmB0YRiynaVE1
rep9e2K89KTJ2/k3f42DsLZAWUnMOhooNlsmYU8NGtdmARxBFo1ZJchaV6NU/PP8
SLP+8kElyOzkIz9QWwnM
=ibSm
-----END PGP SIGNATURE-----

--Sig_/Ky82CY1m2a09NxseJ6Rtz6n--

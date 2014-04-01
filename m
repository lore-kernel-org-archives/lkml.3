Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaDANPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:15:52 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:38409 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaDANPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:15:50 -0400
Date: Tue, 1 Apr 2014 08:15:45 -0500
From: Clark Williams <clark.williams@gmail.com>
To: RT <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, John Kacur <jkacur@gmail.com>
Subject: rt-tests 0.89 released
Message-ID: <20140401081545.2d33d2ed@sluggy>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/PtX_F.BIBD.CxsGslZQ7LBH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/PtX_F.BIBD.CxsGslZQ7LBH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Verion 0.89 of rt-tests has been pushed to the git repository on
kernel.org:

git://git.kernel.org/pub/scm/linux/kernel/git/clrkwllms/rt-tests.git

tag: v0.89

This version fixes a problem with hwlatdetect on distros
where /usr/bin/python is linked to python3.=20

In addition it cleans up a leftover debugging comment from 0.88.=20

Clark

--Sig_/PtX_F.BIBD.CxsGslZQ7LBH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOrwBAAoJEEersVlSw9NzyFoP/0DmFOqLVn8cZTZXgNvRIrjt
Uy9i/y95t1ByEUv9chXRJJqGbfbc2rflOgzMhFqFNKLHji0wmuoF203M/xNlxIhf
GQw1YI/P2SoMFYArszmWNn0fiRR0qImq67RS4MhcZBjqKnqw9bWD75Adf/h08yLO
/JxQHiE/gwoj6NzB7XnhMFoh8PWUtd6uNM7xkPoM0xNrz2yoAhkSpVDuAGJoihGj
OTQziIx2wWPzK1BgvxgnxA/6ThaH9YNlYNlTpezhwoiZUl8y4jc2KCjNDrmFYr1K
0+JsQCgHrwgpbZ9G8W416nxwXxAm9PCc83fgzZOefofR3v7HrUEK8tHFJcetbv+M
ln42axgdphU2s7fMIa6NY7Wten2djUBYdRphn7DVb2WHcOcBwtqX785tt66KtP4Z
N4HCSSlAuk7woyEhc2NNYXhidzyz6ktrJPsq5zBtVM52r+FNvGUSawLHGm7vPlTB
aXe8nfM9boQKWY0PIdc7I98bwqkzYmoY4fXWhqGjMMES+qe19ywU/oaRk+i+6vqU
8uVBGMweGpOTM2MTDePxQdsZz2q28IDvKCvibmZlxAiOpvOOBXn7v59F4Oa5NJ59
lFkyWPA6XyaY8gB5mLonwiA1AIcicaCunYSufar4jafqZwehOYVmDDyrmYzMYfaB
30BWPPXxqP35PFWAUuHZ
=UZo/
-----END PGP SIGNATURE-----

--Sig_/PtX_F.BIBD.CxsGslZQ7LBH--

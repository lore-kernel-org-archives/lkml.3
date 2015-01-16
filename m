Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbbAPEVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 23:21:00 -0500
Received: from ozlabs.org ([103.22.144.67]:41793 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbbAPEU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 23:20:58 -0500
Date: Fri, 16 Jan 2015 15:20:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Subject: linux-next: manual merge of the wireless-drivers-next tree with the
 wireless-drivers tree
Message-ID: <20150116152051.7ce1ecf2@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/NfuPdjV_SwTv8uXMPLVjQc."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/NfuPdjV_SwTv8uXMPLVjQc.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Today's linux-next merge of the wireless-drivers-next tree got a
conflict in drivers/net/wireless/iwlwifi/mvm/scan.c between commit
1f9c418fd94c ("iwlwifi: mvm: fix EBS on single scan") from the
wireless-drivers tree and commit a1ed4025765c ("iwlwifi: mvm: Configure
EBS scan ratio") from the wireless-drivers-next tree.

I fixed it up (the latter moved the code modified by the former, but
also seems to have included the fix from the former patch) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/NfuPdjV_SwTv8uXMPLVjQc.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUuJGoAAoJEMDTa8Ir7ZwV1bwP/0R60PTzflz0/Zz04R/jvd+x
pUVzRKer7+fqpXTCMjxYs2bHpJpgFs5911J5JN5vgQ61Te29BCM7HQ767Bq212kS
+bK5CFqCJ6152If56NG8UsAn/NtfG9yfEDXgVdkWF6xk1d8x/M6WddaQhHENOD61
jT/quz9GiMsbvxi+mLtdEf3TGC6wR4eU0i1ZEPlhGldAg81wE53pAFXRTAi9AADq
6Y9LveUe5dNlMtrpkGiLVsn2lxMPiUf+wDO12/ZnTPkcjRSatNvyxU6WumCGob94
ZFagwjUbZ/r6JSQhnHw4dd9QnAaIHRR3Zbl5+AfDQiPJiZnBRd4b2VPs2v8qbOBv
Rpg/DXiKaDiM5aZ1RLPGaFxoPmNXRiBMibbpOsZeqrhyKpwdG/5KnIxfZT44WLPX
+HF0s2pbm2VkPl6+tH40vLyhbTPbSCDk/q5NYxFMunUVTGYpzp7B2nFV+2NKFcVc
QRe3nAf9BC/TwbG+tjhM1d4hCwZzGObES71acBGbH04X1z/4QqLk05Ims52yIKPd
Luv9cG+JqjTJUuDxr/lsYjLaymeVM+2yBlIBciIdg4e4HXK7xSG91tslIZvK0a44
HnbS6DfHF6fWORBGKbhZUirwCGEHxvnbyg01t4mZGP9001uAA+PBE1lDyRyml1oQ
yJJ+Q0ia/oZFQiHUF/px
=9r8b
-----END PGP SIGNATURE-----

--Sig_/NfuPdjV_SwTv8uXMPLVjQc.--

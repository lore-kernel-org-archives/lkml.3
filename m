Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3A1QGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:06:00 -0500
Received: from 8bytes.org ([85.214.48.195]:53063 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684Ab3A1QF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:05:59 -0500
Date: Mon, 28 Jan 2013 17:05:57 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Fixes for v3.8-rc5
Message-ID: <20130128160555.GA3867@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jan 28 17:05:58 2013
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5106a1e622971071913209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-fixes-v3.8-rc5

for you to fetch changes up to 318fe782539c4150d1b8e4e6c9dc3a896512cb8a:

  IOMMU, AMD Family15h Model10-1Fh erratum 746 Workaround (2013-01-28 15:26:54 +0100)

----------------------------------------------------------------
IOMMU fixes for Linux v3.8-rc5

One fix for the AMD IOMMU driver to work around broken BIOSes found in
the field. Some BIOSes forget to enable a workaround for a hardware
problem which might cause the IOMMU to stop working under high load
conditions. The fix makes sure this workaround is enabled.

----------------------------------------------------------------
Suravee Suthikulpanit (1):
      IOMMU, AMD Family15h Model10-1Fh erratum 746 Workaround

 drivers/iommu/amd_iommu_init.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

Please pull.

Regards,

	Joerg


--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRBqHjAAoJECvwRC2XARrj2TUQAJsAtqA4HNWbIiELsrUGS7fe
jz6/wJqEnZ7qr5QCh/gmR8pJplj9CJR6EBqw5SunRDMYEv+QhbZ2FQx6euKOe3Eh
fk5XPuFCaYOO5T2lpHG2t3PGGTx1yYqsB5Fob2JJMrY15XlNuEvvWACGp4BkiMy2
+eQ2tjzNMaXeDpQhxgxiREKd1jqKE+MQKzG54UL3mc4R8yH6hykoyEvHO3Kp8BkQ
Eg5iKcmyvmffBfcC7gMjXuiE79Elu8YKRfmqxepaW1z0cQA+mJuTeKGjLrjiJVD+
5/TixuFX37idr0KEFUs9XnPajSy8V+1julgXTmT3xlYISj2q+YYHsnCAYDWp3Yci
tUQG8vnOFnE9E7RHpPkw4Mm0v0YUjzmMVTL+uJIHBj3a36LBFb6QWNXVujR9EAEe
3ILw0af/LQ3GwMw5rdvFzUULWoPy/hsFiPxkeQGjZr1gbIR36XrqyVRuImifL9KA
hxno96hP7Nizz0GvwfJSMVjzE3FTACh8tmt5DO3QOIQ07AS0o/iuxSn48buai/bO
6c1FXahpgdu0WsT8TVBnAyvOaxe68a0Om/ZssPtsiFWhAGGNp2nMHsG/frPeKl9V
/864srQRUkoOmlvDuRl/GHjIXCzdiI+r7juS8dka/XEzuP4TZ8xHDnDaGtKc0jI4
pAbaw4OGBJdrmWkP5iDa
=8L7B
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--



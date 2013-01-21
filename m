Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3AUEVp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 23:21:45 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41654 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab3AUEVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 23:21:43 -0500
Date: Mon, 21 Jan 2013 15:21:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>
Subject: linux-next: build failure after merge of the usb tree
Message-Id: <20130121152132.bbcc78f7d2b20741734d0fd2@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_Jan_2013_15_21_32_+1100_RuVv=NQFAQEoCE4k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Jan_2013_15_21_32_+1100_RuVv=NQFAQEoCE4k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/usb/core/port.c: In function 'usb_port_device_release':
drivers/usb/core/port.c:25:2: error: implicit declaration of function 'kfre=
e' [-Werror=3Dimplicit-function-declaration]
drivers/usb/core/port.c: In function 'usb_hub_create_port_device':
drivers/usb/core/port.c:38:2: error: implicit declaration of function 'kzal=
loc' [-Werror=3Dimplicit-function-declaration]
drivers/usb/core/port.c:38:11: warning: assignment makes pointer from integ=
er without a cast [enabled by default]

Caused by commit 6e30d7cba992 ("usb: Add driver/usb/core/(port.c,hub.h)
files").  See Rule 1 in Documentation/SubmitChecklist.

I have used the usb tree from next-20130118 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__21_Jan_2013_15_21_32_+1100_RuVv=NQFAQEoCE4k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/MJMAAoJEECxmPOUX5FEbiQP/04uWju9yOnFQFQdruUQIZdt
8mjsuBCoj6v7Yv243P35cQzSLzQ1EM8mokE8LT6Zjhsc7zWNt8CjOD/kfBTMBHWv
pjx5Ililk73EoU4XaqbyvEpqLr2UGMHHBBfTT5wMfkNEYdFgXr2faErz2o3cr/hA
Ks0AU2jgEPXiU6469Wq2Ukz5glAwLtuJEwWdQHwXyziTeWhF+bu8PlnGqU7WqfL3
CGNBswkTwXvdZIxOZ0oywD/zvCp52oL34veFptJWrINz6p5NbPMBaWGM4EVcdEno
2AdnAAwWLYqaxqsUEzA7+n225+SyklWz8+TD+0p6/2wfqB8DmVwwGmUbaR/d4QkS
jWtdrAanyrls7T8odO+tjihZoqbzPGr3Rd5G7zGjFu7l4qoqZlc/MZVi6b9J1Zmx
5FG6fPkK0VU7ROmcZRilm9Qb4/P4z+9CmveoH0yup6QwphtFesyN3CYBbSqsCf3p
/MxKW0fhhOo4FrL0hMRBk2wN00UtPMRdF8KKrzRRXJBxa/L7wse7ugy6Y9NttlyQ
JR5dxTazwy1CUASEUlTeUlJrwS4ETI6FODhxt5TNhZBYTaxmUBEIni2VoFWGHSc9
49pyeZkzW6nf5CzYvs5BpYnpuslOduPdkBLMnrB4RdqGc/PiZH09fDh2OIKxEBHU
m2O0vTx36mLdcsMqDH2g
=y8Dh
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Jan_2013_15_21_32_+1100_RuVv=NQFAQEoCE4k--

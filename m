Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab3BEBqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 20:46:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52355 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab3BEBqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 20:46:14 -0500
Date: Tue, 5 Feb 2013 12:46:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20130205124610.2e725fbc5a08983bf94932a0@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__5_Feb_2013_12_46_10_+1100_vQRfxRN6DjZlHajO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Feb_2013_12_46_10_+1100_vQRfxRN6DjZlHajO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "regmap_async_complete" [sound/soc/codecs/snd-soc-wm-adsp.ko] undefi=
ned!

I have used the version of the sound-asoc tree from next-20130204 for
today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__5_Feb_2013_12_46_10_+1100_vQRfxRN6DjZlHajO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREGRiAAoJEECxmPOUX5FEW9YP/2L1t222b8oopwABJRmMKpLz
8d9aiqPeAgyAf5/xKyfN6XRlqErxNJzBt5sI0cDD0bVSa/WYIz8qyXwTQ+ydC/FB
BGInbzm+bJbqySruQ68Nwmpkv2OEr11fMMsD37nzRoEQCDXyfB0nocwbUn7+PTqO
VyRv/1tpDEMgCU2wiSX0RNZvoQNXSckQ7SUiE4DVRH+qbKeIPogYDqairvoBmhIH
9ukdHufTmnCdEMin30dUzq+KTI0mlBlZ3jupxaKnOFoBVImURx5IpFJrU5kMAdI/
uH0IDlYqY17ff6H9g1opbuPNYmq/9ABnbcTfDWM2Fh/AV+quLVIJndHeX20XJYuh
hCRk2WGsSjrav/+HKcU1d6AsGkFiWpiPv5F4ms5vzw2N2zsEPGHep/DtHWJ0o8Ip
A9mFW6jlsM3GxCgenpyID/e2nM+gVuWejAQVVBBZOZQ3M/oqOokk/5wuJk2JBWDt
iltVRk4NEDUyZJfF1TsuwCp6N8586OkiDbMAe2mI2fpX4KYnpfNEa316Q4vjCXR6
1GPgg+iKYmOPbnE7WFcf27IEgfeNrhazjPHDBi0p+CaQDomvk94XmUIUpgVS2Yfq
aKkaq4X7Lv+ruTIyQ/Ez5VdbOqJyef60RwDGJg1IjFqEv6iBIVSJZ5EXIFelFazM
3Cips2hAgy0oxj93gb/J
=EpKF
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Feb_2013_12_46_10_+1100_vQRfxRN6DjZlHajO--

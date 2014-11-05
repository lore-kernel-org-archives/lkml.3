Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaKEA7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 19:59:08 -0500
Received: from ozlabs.org ([103.22.144.67]:46412 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbaKEA7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 19:59:06 -0500
Date: Wed, 5 Nov 2014 11:58:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the f2fs tree
Message-ID: <20141105115858.047a7a60@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/L=_W4c97BplK_7=3bcc5sqk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/L=_W4c97BplK_7=3bcc5sqk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jaegeuk,

After merging the f2fs tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

fs/f2fs/data.c: In function 'f2fs_write_begin':
fs/f2fs/data.c:960:19: error: 'fi' undeclared (first use in this function)
    set_inode_flag(fi, FI_DATA_EXIST);
                   ^

Caused by commit 2bac4643efc1 ("f2fs: revisit inline_data to avoid data
races and potential bugs").

I have used the f2fs tree from next-20141104 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/L=_W4c97BplK_7=3bcc5sqk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWXZXAAoJEMDTa8Ir7ZwVMuwQAICV6i7Oo6z71XgP534frgwZ
iPM8p/Kb2cE2P3J0/V6DMfyraqpzrsP8XhefasaDx/fChVwDQja3SiSeKAXkaeYK
WmyxQB07OxqtNY0Ymap9ookQzavErvCfLaluenTaffZEIfiarTeUvTQXJqo+S4Vh
XKBwjy0tH4e6XzKltqE2kK/EVg71V+Pm/HL0elT2MV7E7UAHCmO2KIA2NLke229Q
EjaWpnSsYYJk78Y7rCqnpR6adfAE4HwNN8KvEbB3DNfErMZaX7yiWKAXDtJcqfzC
7msC8KtWtDqESfGg9DhxbFnevAGJFgs9g6F0Ra2NKZ4R+3cnO7fMMvdBdW2swKJ4
1MfSI39X/hDx3wbvYYtmQhD5KykvUs2cqLTBvaUz/LCR2LFLkoYdnM+I8DZQ6W4O
XFabbeoByOec9QIQMF6Xx78xLSvrbOqD2iFIBqYEarxmttBhkit7nMpq0F8kAr2C
VtWYTSceEzdNINCW/vooxOKmGoQMqAD5HWRh41ZJ+48zES2jXN6Z1Uyp3qT5Ssnz
+ujG35f9QqNrDqea95pKCJyeaPPuDyIa+eBvF4rLqJyPfQafvtklt1Kva3MaNGrK
goKKRQPSUqkiMmUVkNVKq+36AQ1YzKUP1SRjYwUrvJn48bVbIPs8j3XmjArRtsn+
zlof7ESXsCLqKx6KvFBq
=X2Xh
-----END PGP SIGNATURE-----

--Sig_/L=_W4c97BplK_7=3bcc5sqk--

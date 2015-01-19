Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbbASGIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 01:08:51 -0500
Received: from ozlabs.org ([103.22.144.67]:33453 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbbASGIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 01:08:49 -0500
Date: Mon, 19 Jan 2015 17:08:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andy Lutomirski <luto@amacapital.net>, "Luck, Tony" <tony.luck@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: linux-next: manual merge of the luto-misc tree with the tip tree
Message-ID: <20150119170839.2c6b4b78@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/YX=zQtIt6zEc3e58dto_EQ+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/YX=zQtIt6zEc3e58dto_EQ+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andy,

Today's linux-next merge of the luto-misc tree got a conflict in
arch/x86/kernel/cpu/mcheck/mce.c between commit 83737691e586 ("x86,
mce: Fix sparse errors") from the tip tree and commit d4812e169de4
("x86, mce: Get rid of TIF_MCE_NOTIFY and associated mce tricks") from
the luto-misc tree.

I fixed it up (the latter removed some of the code changed by the
former) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/YX=zQtIt6zEc3e58dto_EQ+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUvJ9tAAoJEMDTa8Ir7ZwVqQIP/jhBXQ6Lr/KD7eM/1RioApfv
B1qqbND91Oz6ADLJwgVEhwQdestzOUhRuBMC1SUy1P0Il1RvGF6muwcR8lHpMv1k
BtasN75RhJQ1TvtmW2fbAotKU++183jeMJFTi/TDhR4vrpbtaBylFUt16TtcS8dV
S/qTlTrJAI3MmHJbr1yj+INvJ9PbojY4tRqe01zFDJWbK0XTyngZigM+KgNRF32+
Pr8Wk6ykoXrtPKjOhisjKu8OReMyft83LObY4VKgjuWZqb/al+F+T+SivoiHeOPN
kEqyMebwtcqrYOj4gBaF47dLBPc+92ah+vzNlAOOY7gBJ1IStkohw7WbkRebvcGa
bMXeU+itos2J88ItygmOENJ/Yrs21nS0+GCGrEgRdKtHym11Ql9n4a+MWiIRCA5y
gelBDx0qDsBS8LyOy5KBjj9MaskTLJFjLl6yojS9OyRR36tz8JRT5dWmdFmMvp6S
BBn01XShkKhlfBRJB+Acml69JVDmw10shLWXDwwiX5snVOC8xmjuhkTI2kHeN4O9
yJIxUnkSrdnfmA8UUVxlY2OFfP76utyWWt2sG5IVeEUS3CkO5uedh1/D01ExRlGG
5nJxVbofOL7kJdUnN+9iMKHFZVIfKj3Sf6YnIqdnbgYqkMzNBlypV+mKOTOPtvmo
CAcNzo3rkyW8xqBapKhU
=+BsF
-----END PGP SIGNATURE-----

--Sig_/YX=zQtIt6zEc3e58dto_EQ+--

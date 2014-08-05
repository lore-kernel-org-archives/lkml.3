Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaHEA6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 20:58:52 -0400
Received: from ozlabs.org ([103.22.144.67]:41037 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbaHEA6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 20:58:51 -0400
Date: Tue, 5 Aug 2014 10:58:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: linux-next: build warning after merge of the tip tree
Message-ID: <20140805105839.35555b3b@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/uSj5hiqW.EH5YDVanoGmKhL"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uSj5hiqW.EH5YDVanoGmKhL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, the linux-next build (x86_64 allmodconfig)
for some time has produced this warning:

fs/cifs/misc.c:578:1: warning: 'cifs_oplock_break_wait' defined but not use=
d [-Wunused-function]
 cifs_oplock_break_wait(void *unused)
 ^

Introduced by commit 743162013d40 ("sched: Remove proliferation of
wait_on_bit() action functions").  This commit is now in Linus' tree -
sorry for not noticing earlier.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/uSj5hiqW.EH5YDVanoGmKhL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT4CxIAAoJEMDTa8Ir7ZwV2N0QAI16sFXbc6JPGBnnSZQhJjYc
b0u6Hc/IUNP8hVpC940qF0Nq6zXppXM9xgrQcxSrGHpVlgbp4Z04lwM3STxmFhDD
kwV667MsXGqdSfBIq5haUo9qHBr971LA9XkCsKCvSTBoqBMPGLYNdxx/CUtQIG0+
uTj4tKV3BhTe2uJliDpWeqJqzZM5arzaxnXCW1YJNeYCLB/r2lLvp+6rtwweF7qk
4PWjxYUVOc8+pcCdA+JhCI3C7eHofukuG3yRkqNjQZ0QGJjjqGH8K2gxgn9BAxkC
5M/dn3qpBDX9GX6IP+u0sadg6Zrkzykikgwfaa6Xw2pOGXHKzB5pKtMQCZjcmBeL
las6TVgEx1Jil52aKeYLF/408ueAcQ4ePu69pTLQoksWtgX9QaGfsj433OAavxiJ
HjZlQw5FAEDJ3OiTCnXz9HTswwVgxkyz2mW3/yw2HmLjnBnKsZzcLrNfoU3eTJiL
OWeg8DlH5bFagwFc6syrB5rlOWoRPgsLreY7zXJ9d+fd+tHeY9PS72X1iKxSeAT9
Bwp+EKacGoS5PkC9+A0M15wWjumDlAlDQFENnQDioluCuNhQTXG4Aux45xrNPYIL
q6FjECw5o6xAdIzBFUKu4CKvew5ZCOaKDYYGFIeLzY5Mehm2qv4Nkpdpgd/phEOM
J/RCg5b2trhf1zcFZLPz
=H5uu
-----END PGP SIGNATURE-----

--Sig_/uSj5hiqW.EH5YDVanoGmKhL--

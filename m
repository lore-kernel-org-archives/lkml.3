Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaI3IJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:09:47 -0400
Received: from ozlabs.org ([103.22.144.67]:39678 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaI3IJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:09:46 -0400
Date: Tue, 30 Sep 2014 18:09:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20140930180938.283897d2@canb.auug.org.au>
In-Reply-To: <20140930075239.GA28481@linutronix.de>
References: <20140930173900.51839e76@canb.auug.org.au>
	<20140930075239.GA28481@linutronix.de>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fpnbBckKspFqOpNBREBl=L6"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fpnbBckKspFqOpNBREBl=L6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Sebastian,

On Tue, 30 Sep 2014 09:52:39 +0200 Sebastian Andrzej Siewior <bigeasy@linut=
ronix.de> wrote:
>
> this should have been fixed by commit baeb7ef34952f ("tty: serial: 8250:
> use 32bit variable for rpm_tx_active") in Greg's tty-next tree. Isn't
> this the case or did you fetch the tty tree before Greg pushed it?

Presumably the latter, in which case I will see the fix tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/fpnbBckKspFqOpNBREBl=L6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUKmVGAAoJEMDTa8Ir7ZwVT5sQAIFiyzP02bJFN0bDtuM0eB6z
FONNdO+6zc8K1BQX+FxF89GKMzs/lQyK3cbvyIOYkXpKxtrSudwv6UoYMhqAOyBq
Y2NfmsiZaxc//xkHf+aJ3u8RUoBg76LhTM3B0O2SZAbTjDOZ0mVdeOANIhQLU7xY
tp4xMXmvUa1ErMh9lrvC/of1KUHQpq4839BKfF7kH31e9AFKkBlBcQb5fi8emJK4
56HDDlmRbC1ztRgHD5etViBfzNvrhgit4Jox83gxHrf83a5xR+6rNkv9wpWsNBLk
C6pxEWEtOtFgsB/tWw64RNT0JEQ9xt4Hoo/KvA92gteqDyPlQleh00jA952D2Ynv
wUvBSuDR1UvTHAwm4CfdMY3+WCaYFHtx+ySpm3Hi1YnoQLACYq6AAlWfBCmNW5qq
CJcN7u1BPeBD3JmNoI2+TKME5O/M7ma9RocE+56PWGtdU8KCzq1enBYCAI/prlG2
9uq9GNAcEJhbtI6AGrsJmNbZlJSSsFcW9CCGp5hLHQf9YKdjLU3PdtQMEOW+dBgO
KSzeSzzsRkXmbQ0v9mRTl1vfcOb2vDipczdHpIOs413Ys0cTBJa4h2yrulY9dDOc
tkQ+QuHEVaq2HRC9ymluG3URdKFRFwC+IbSn/i2KQhrjyqxDN9xI8y/daTpcdcjZ
ACv7rQ4b3iH6QklQ0Toc
=RbGa
-----END PGP SIGNATURE-----

--Sig_/fpnbBckKspFqOpNBREBl=L6--

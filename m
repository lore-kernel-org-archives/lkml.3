Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaG3XuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:50:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbaG3XuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:50:13 -0400
Date: Thu, 31 Jul 2014 09:49:10 +1000
From: NeilBrown <neilb@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Ian Kent <raven@themaw.net>,
        autofs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] VFS: allow ->d_manage() to declare -EISDIR in rcu_walk
 mode.
Message-ID: <20140731094910.20bd9f9f@notabene.brown>
In-Reply-To: <20140730201652.GA23156@infradead.org>
References: <20140730160833.5eac00ec@notabene.brown>
	<20140730201652.GA23156@infradead.org>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/l5V6yubzZ0.mI73jlyTdety"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/l5V6yubzZ0.mI73jlyTdety
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Jul 2014 13:16:52 -0700 Christoph Hellwig <hch@infradead.org>
wrote:

> This looks good enough that I'll apply it to the interim vfs queue.

Thanks!

NeilBrown

--Sig_/l5V6yubzZ0.mI73jlyTdety
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU9mEdjnsnt1WYoG5AQJQvw/+KPhOc7es7mQqknLZod3/oKLDC2dZ+/yL
R3ZS/I6Ez7h1cSC6wf4NenYs3j1ypzYinLjG2cOzMJeKdwri4mRbpM/7UKoTuTHi
VBwboxHsomLyKuGAk7FNFQRMP3e4pFun63eMC4ddedMF/p8D1i7QmROulg/WGYfM
Zip/qa0SG3fjJDARuQK6vyLB1kDT1QQIDX1VR6o7kZMJ6jMzQZ4YMsQEZxkDMNJL
sLNfNC8w0yRpaM97vxmhkO322tPO44U03jYbDlmaG5w0C7U+F+fL97GPDJuz3Fwf
bfQDmrZeksH0BawvbP/+j9EV+60oA5omr8gGzKPfBxP3D/VFWYT7YylQrtJ7v9UK
O5BaOCvtOVlIKQQuKJPQGURkM31gpW/XuyfCYmDo6PAZs1NX6K1XI6X7SGeyMCkk
vzP/ME76dz1K1Okq3UeltTsnBwnNo1AwC2seENy4P7+EQjWXFDXCgVsG/Fwxn9i+
iEXi0nodrBAXUDX1TrYQmJp5nFmE5NJ/jnXrowr4jTrA/muAZoEVUB7IYVORPOdM
c02EDuBlrwf/wut6v7kzrg98wzFB9wgdBeHzJfrHsPpbqrkbdgbQe6lvJTjXTH73
pozLhhNegsFjhzyCJXTHdZiax73JN+e7ota4efRlg9qFoGDfIaYP1C7X/8V6oLci
WlHqML2/yvk=
=nA1A
-----END PGP SIGNATURE-----

--Sig_/l5V6yubzZ0.mI73jlyTdety--

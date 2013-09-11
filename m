Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3IKEbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:31:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54807 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3IKEbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:31:03 -0400
Date: Wed, 11 Sep 2013 14:30:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130911143047.8cc69ea05e0d2c1e4db9fbd9@canb.auug.org.au>
In-Reply-To: <20130910161302.75efbdd7a3a0e6fccc797804@linux-foundation.org>
References: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
	<20130910152753.662599171456233c5f91edb4@linux-foundation.org>
	<20130910222924.GB13318@ZenIV.linux.org.uk>
	<20130910153520.14e49cd32feb16d45eb8abac@linux-foundation.org>
	<20130910223624.GC13318@ZenIV.linux.org.uk>
	<20130910154116.cc4afe048213a779040ea3cc@linux-foundation.org>
	<20130910224823.GE13318@ZenIV.linux.org.uk>
	<20130910225934.GF13318@ZenIV.linux.org.uk>
	<20130910161302.75efbdd7a3a0e6fccc797804@linux-foundation.org>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__11_Sep_2013_14_30_47_+1000_QwZtL_UrO0g0M7uQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Sep_2013_14_30_47_+1000_QwZtL_UrO0g0M7uQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 10 Sep 2013 16:13:02 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Tue, 10 Sep 2013 23:59:34 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrot=
e:
> >
> > It's not that bad, actually; I think the variant I've pushed right now
> > (vfs.git#for-next, head at f5e1dd34561e0fb06400b378d595198918833021) sh=
ould
> > be doing the right thing.  It ought to cover everything in your branch
> > in -next from "fs: bump inode and dentry counters to long" on to the
> > end of queue.
>=20
> That's the correct starting point.  The end point should be
> "staging/lustre/libcfs: cleanup linux-mem.h".

OK, so I have removed that set of patches from the copy of the -mm tree
that is in linux-next today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__11_Sep_2013_14_30_47_+1000_QwZtL_UrO0g0M7uQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSL/H8AAoJEECxmPOUX5FEFDsP/ROJLp3UZK+Cm20F5Un30/Nx
u6hOjrsUgwiivliMQiEv/q0u8VshtwSi7hKH71889aDa8wgMktZl3HR7jzX63Ezm
4dDMiFg1/E2iBxcFW/bJeiAjUvLJpxf2jrZoHMyU6AVVsM50jGRK5zpKEPcl6/x7
+hNijigOLPUYmybP3NFA6Dc0s/4RsTPi20dgL9LG3iUHtu/dQ4xcrwJke56rISDL
SSbmZXES3wMC6YUCIVgb7aXDNS2yf9WSHH7ghnkh62RVZ8YrPdc+sFfrVpkmngE2
/bBJ5gxL+/OpyBAvk2Zi8/54CNXNSD7oEMML9JBaqCkMLa7VTg70JLIednzu+SHP
yyiywzRI9wBchj0BTkkqZqlgnmna74IUbKQTksy9kGna7PQSPIrB92eEyeY4BBUL
fSWDUMq95xJzdILBx1sewDfrR1f0QyZC4VG/7ihtpgapXN56flTH3VNvbMZseePv
uZSdB412u366P+/GmR9Km8DTgQSsE5Nr9QOwe6QC1HAX7K/U0tbFIpgtBpW0LZJj
ohrfG/PRhYUbcQuotxL0bdV4GtB6aGoOm+bFpjftGxq8A7PNlLRc1hTpZ8evRXkh
Lu90uw7TH1nyFqwrt6wXkMAjpUpeIH1vo/wCbuJnGxCAzDnNP/WHw/DYyOqH4Qkl
1kAsy0YyHIfL/f646EL+
=5Mqn
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Sep_2013_14_30_47_+1000_QwZtL_UrO0g0M7uQ--

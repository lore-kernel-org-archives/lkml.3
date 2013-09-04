Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934274Ab3IDBzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:55:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45257 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761645Ab3IDBzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:55:52 -0400
Date: Wed, 4 Sep 2013 11:55:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Subject: Re: [tip:x86/smap] Introduce [compat_]save_altstack_ex() to unbreak
 x86 SMAP
Message-Id: <20130904115543.0382a853faea38d8c13e1124@canb.auug.org.au>
In-Reply-To: <45ca0da8-f75f-47e8-b310-8b4926b32b69@email.android.com>
References: <tip-es5p6y64if71k8p5u08agv9n@git.kernel.org>
	<20130904111109.a324685422cf680403678e4e@canb.auug.org.au>
	<45ca0da8-f75f-47e8-b310-8b4926b32b69@email.android.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__4_Sep_2013_11_55_43_+1000_GdG5=s=PnsNQ/VNb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Sep_2013_11_55_43_+1000_GdG5=s=PnsNQ/VNb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 03 Sep 2013 18:12:47 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> Header file dependency hell.

Ah, ok, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__4_Sep_2013_11_55_43_+1000_GdG5=s=PnsNQ/VNb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSJpMiAAoJEECxmPOUX5FE4cQQAJq761r52qYvfmq2YWp0eFm6
gpBZTfB335ZooCsPigQ6X8cD4gx4NTKZ3SL1+fiQHGGDivnAZjHH/6dXBPgSTIpO
iqQctUex3mPSGdyDM2kxaDOastEqn03klpsb6b3MJfSoJpUtEeHMwmSP3SGBqGLr
BfC3j0bsiJunrtHnpMAV6ollliI7gLJn+5YWpD+TWYPIPigMWh6XMYNZjZ0M01DG
Q+av0d1frv2m2XT2QQcV5+o9gh6A3DYFTIrYflq/8xZJm4iJQ4yyrKNen1LfRrZQ
bFEzHOWOtMf6XRIu27mw/9BV2G2M0AvJDuHzB3iqMZy2S/t9nhbU6y2vR8F2dR4B
f3LSW3a3quDGXXuLJBOEgmmnOYwccJfUPyluVQIaj1hQd2FWdrQXDvVoop+1BZNN
ciRN7b+ANZsnJkfGJuvb/EtgwFQgsh0zR8emLu9uY1k8nRvOOQ7vQJ022pLFjyg4
vQOKlGCSpNwdHgnli/kC1ToJzBS451klXzGc2VD7BShz+tqRys/8VJ1tb3vWEFAQ
Ce3zR5poEZPKP6Azper8OZ9TiWtVIcZwaiJ2hY+N8ABVz8I846jiSA7HF4iguUI9
TUvmB/+qeGpBW8UNOTsHUxFWAmyTEzZ6FKo9dwzXViZxoy8oDlWnPSp9Fa8XpaP8
uO+CAWuuyNI5SgeR4bl8
=l9Lq
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Sep_2013_11_55_43_+1000_GdG5=s=PnsNQ/VNb--

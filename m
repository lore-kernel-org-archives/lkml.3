Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab3GKGxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 02:53:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51774 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab3GKGxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 02:53:52 -0400
Date: Thu, 11 Jul 2013 16:53:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: rebase of the jdelvare-hwmon quilt series
Message-Id: <20130711165343.f921e147403570508939f2df@canb.auug.org.au>
In-Reply-To: <20130711075700.21d8482c@endymion.delvare>
References: <20130711102724.51608a4ace419b6d42591257@canb.auug.org.au>
	<20130711075700.21d8482c@endymion.delvare>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__11_Jul_2013_16_53_43_+1000_Xw+Bkt5vcZVclzTU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Jul_2013_16_53_43_+1000_Xw+Bkt5vcZVclzTU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Thu, 11 Jul 2013 07:57:00 +0200 Jean Delvare <khali@linux-fr.org> wrote:
>
> On Thu, 11 Jul 2013 10:27:24 +1000, Stephen Rothwell wrote:
> > Why have you just rebased the jdelvare-hwmon series
> > (http://khali.linux-fr.org/devel/linux-3/jdelvare-hwmon/)?  You have
> > just invalidated your testing and made it likely that Linus will blast
> > you if you ask him to pull your patches.  Your whole series was already
> > based after v3.10 (i.e. released or rebased after the merge window
> > opened), so why move it again?
>=20
> I'm quite confused by this complaint of yours. I do not have the
> feeling that I rebased anything or invalidated any testing. And I don't
> think I did anything different this time from the way I have been
> proceeding for years.

Probably not, I guess I have been getting more sensitive lately.
However, you have changed the base of your quilt series.  This means that
you have included more changes from Linus' tree into your tree, thus any
testing you have done previously may be invalidated by those changes.

> I had only 2 hwmon patches for Linus for this merge window:
>   hwmon-lm63-drop-redundant-safety.patch
>   hwmon-lm90-drop-redundant-safety.patch

Yeah, sorry, but I was complaining to several people today.

> They have been in
> http://khali.linux-fr.org/devel/linux-3/jdelvare-hwmon/ (and thus in
> linux-next) continuously since May 19th so I'd say they received pretty
> good testing. I did not touch them, I did not even have to refresh them.

Actually, those patches only hit linux-next on July 9 (my time), when the
were based on v3.10-6005-gd2b4a64.  Then today you changed the base of
your series to v3.10-8587-g496322b and added another patch.

> 3 days ago I added these 2 patches to the hwmon-for-linus branch of my
> staging tree:
> http://git.kernel.org/cgit/linux/kernel/git/jdelvare/staging.git/log/?h=
=3Dhwmon-for-linus
> and asked Linux to pull from it.

Which is probably when they hit linux-next.

> Yesterday I reviewed a new (trivial) hwmon patch, and I accepted it, so
> it was added to http://khali.linux-fr.org/devel/linux-3/jdelvare-hwmon/ a=
s=20
> hwmon-w83792d-update-module-author.patch (and thus went to linux-next.)

And I have no problem with maintainers making judgement calls about
simple patches during the merge window.

It all seems a bit trivial when we are talking about 2 patches, but it is
the process that is important.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__11_Jul_2013_16_53_43_+1000_Xw+Bkt5vcZVclzTU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR3lZ7AAoJEECxmPOUX5FEpvQQAJuGfNaK2+8q5vDpBd2URgmT
Uns7ljZLl67dvofuzohvPXDqflAlXkyraekrZnM34YTsn6WCq9CF8iwVf7L/sQEW
IVp+szdfIvMoiUOiv91vHagV+4Wf4ZGMea6UhxvUCSyp7PeeVKMcJq2+a0HPpiR4
hAI+azuNNIoGlMX/vkjryu+CNoiaPKFNA8R03U/9EXps15AQs3/MXkXXNtxtbxTi
hyApDrwwjv1ayy7SXWbLlC6r1K4LEyjZaQZWiQAnkzMGySXiVWalNXsJ1KVLhPme
9KViTlHgKqLvz8RFzypnVnpZuuU3984CAyXRmz/subcBM5RYLmzE/SFayYwWX+5+
xxGBhpseFkjUPqiX/0w7euy6i23K0+DbgBNq9oqYgVmeGrKBZrCqZwscOR+GHZHm
AteuQT5YLzoeUIZ+z83VPIR65TKO26gv/I71YglmhZk2NYy7e3QBXnFP9LYOvUpU
wAhpLYTY9R9XwrQbrtGw+IPKOZI2XjP9hMxMsixRfuxT0XyC7hVRIAdfuRrx4ywj
Gy3mKhHzN593//Exdc3DzJC0WBbNCupJPYmZLmF511bthkT02oA+kRNEFPsV/mL+
Af35JfMswH/IcdyaOkjKARVHuS6n9FXxEFKZ2mxzHBcDbGeIraUzpkeXJVEb3BSP
8xhaSU2HxyrUpUd0ZFYY
=togL
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Jul_2013_16_53_43_+1000_Xw+Bkt5vcZVclzTU--

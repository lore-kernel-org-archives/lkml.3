Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935511Ab3DII5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:57:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25160 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935193Ab3DII5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:57:09 -0400
X-AuditID: cbfee68e-b7f946d000001e37-aa-5163d7e344f4
Message-id: <1365497775.4353.69.camel@kjgkr>
Subject: Re: [PATCH] f2fs: move f2fs_balance_fs from truncate to punch_hole
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Jason Hrycay <jhrycay@gmail.com>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, C.Fries@motorola.com,
        jason.hrycay@motorola.com
Date: Tue, 09 Apr 2013 17:56:15 +0900
In-reply-to: <CAKYAXd_TUmZ4TM_v3bYyD7gyAnZ9hAoZ5sMmV3kGJe0BLqu84Q@mail.gmail.com>
References: <51636BFC.6040607@gmail.com>
 <CAKYAXd_TUmZ4TM_v3bYyD7gyAnZ9hAoZ5sMmV3kGJe0BLqu84Q@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-FBDcvPKDreM3Td6spHyU"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+Zse7j68mBBsu3CVls+zSRxeLtv/PM
	Ftc/b2CzuH73FrPFpUXuFpd3zWFzYPPYOesuu8fuBZ+ZPHpOvWX2+LxJLoAlissmJTUnsyy1
	SN8ugSvj4dW3TAWLRSseXu5ia2B8KNjFyMkhIWAiMX/PcUYIW0ziwr31bF2MXBxCAssYJRbd
	7GbvYuQAK7q4zxSkRkhgEaPE9Y2eEDWvGSVO/73FClLDK6Aj8WKGOUiNsIC3ROeqPWwgYTYB
	bYnN+w0gWhUl3u6/C1YtIqAmMeFZKsgUZoH5jBLrT/1kAalhEVCV+L1yCTuIzSkQLNGw4jwr
	RG++xIwPO8Fq+AVEJU62fgI7mVmgSmLn9cVQ5ytJ7G7vBOvlFRCU+DH5HgvIAgmBqRwS2yZs
	Z4dYICDxbfIhFoi3ZCU2HWCG6JWUOLjiBssERvFZSMbOQjIKIq4p0br9NzuErS2xbOFrZgjb
	VmLduvdQNTYSm64uYISw5SW2v53DvICRfRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGSEz3
	7WC8ecD6EGMV0IkTmaVEk/OBKSGvJN7Q2MzIwtTE1NjI3NKMKsJK4rxqLdaBQgLpiSWp2amp
	BalF8UWlOanFhxiZODilGhhX3biWvWB23dTkE/4mud5JN/6tfiSvYxMixOcb8lUvv7PpS1CK
	ri/jBpU3T2507WRRUY3SrFjxpd9Lxk8k00Iu1uVr87PWpHeep486Tz7kbVllqmS1q67qX7jG
	0xfZsZx73qcd2BRfO7W4f/qTt4cT5zLPiTxz40X64qlGTVJ96nfeX7JwK1FiKc5INNRiLipO
	BACxC1DdFgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42I5/e+xgO7j68mBBvuX81ps+zSRxeLtv/PM
	Ftc/b2CzuH73FrPFpUXuFpd3zWFzYPPYOesuu8fuBZ+ZPHpOvWX2+LxJLoAlqoHRJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdouZJCWWJOKVAoILG4
	WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4+HVt0wFi0UrHl7uYmtgfCjYxcjBISFgInFx
	n2kXIyeQKSZx4d56NhBbSGARo8T1jZ5djFxA9mtGidN/b7GC1PMK6Ei8mGEOUiMs4C3RuWoP
	G0iYTUBbYvN+A4hWRYm3+++CVYsIqElMeJYKMoVZYD6jxPpTP1lAalgEVCV+r1zCDmJzCgRL
	NKw4zwrRmy8x48NOsBp+AVGJk62fGEFsZoEqiZ3XFzNCnKkksbu9E6yXV0BQ4sfkeywTGAVn
	ISmbhSQFEdeUaN3+mx3C1pZYtvA1M4RtK7Fu3XuoGhuJTVcXMELY8hLb385hXsDIvopRNLUg
	uaA4KT3XUK84Mbe4NC9dLzk/dxMjOGE8k9rBuLLB4hCjAAejEg/vhSdJgUKsiWXFlbmHGFWA
	5jzasPoCoxRLXn5eqpIIb7dhcqAQb0piZVVqUX58UWlOavEhxomMwOCYyCwlmpwPTHN5JfGG
	xiZmRpZGZhZGJubmtBRWEuc90GodKCSQnliSmp2aWpBaBHMUEwenVAPjzJcC4cVuib+/irj/
	LZrKqahc/LCos32uYenqngO2Ljf0op7//Sl5uoz31WW28mf72guf28fM+/VMSk/s9gdNrTXb
	piQwqrvuK444LxZ8qzIiOfVtyAOGYtvDwUrtsxwCttYaJc5pPPLLf2HgEamSi2J/gm823X3M
	VNEltKsz6d3e2Okuc4KUWIozEg21mIuKEwFIy3AJlwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FBDcvPKDreM3Td6spHyU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-04-09 (=ED=99=94), 15:46 +0900, Namjae Jeon:
> 2013/4/9, Jason Hrycay <jhrycay@gmail.com>:
> > From: Jason Hrycay <jason.hrycay@motorola.com>
> >
> > Move the f2fs_balance_fs out of the truncate_hole function and only
> > perform that in punch_hole use case.  The commit:
> >
> >   ed60b1644e7f7e5dd67d21caf7e4425dff05dad0
> >
> > intended to do this but moved it into truncate_hole to cover more
> > cases.  However, a deadlock scenario is possible when deleting an inode
> > entry under specific conditions:
> >
> >  f2fs_delete_entry()
> >      mutex_lock_op(sbi, DENTRY_OPS);
> >      truncate_hole()
> >          f2fs_balance_fs()
> >              mutex_lock(&sbi->gc_mutex);
> >              f2fs_gc()
> >                  write_checkpoint()
> >                      block_operations()
> >                          mutex_lock_op(sbi, DENTRY_OPS);
> >
> > Lets move it into the punch_hole case to cover the original intent of
> > avoiding it during fallocate's expand_inode_data case.
> >
> > Change-Id: I29f8ea1056b0b88b70ba8652d901b6e8431bb27e
> > Signed-off-by: Jason Hrycay <jason.hrycay@motorola.com>
> Hi,
> With the latest commit 9995bf953a83749abd9fa22f72ab2b0be341025a
> About introducing the global locking method in =E2=80=98f2fs=E2=80=99,
> I think we no longer will have a case of deadlock happening in this path.

Hi, Namjae.
I found that this bug still exists in the new locking model.
Please see the v3 patch. :)
Thanks,

>=20
> Thanks.

--=20
Jaegeuk Kim
Samsung

--=-FBDcvPKDreM3Td6spHyU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRY9evAAoJEEAUqH6CSFDS05MP/jzNGOqOd0yffZwJl1SZrFTL
J366ZihBmZ+3HUjZNQMotRlFoUEp6cBmLbXv7FwMRprAMTT3Et18GjsTFuU/vwov
K65jPvEmtrGAkOzDSDdUk+DVSeX5Owm0EMOuno6TXkyEUcofgdI/Mgc1MA48brgI
ndwXjVKQgc5H7XCvUeZ680jhvlvZodGMmLVXu8B1e4XF1bhm5Yrs8O1OzIVlYgqO
TQ6vWqGcHw5L4ikS9TcHNy8HaCgKA+vqfGgtKmUAvCeuSgcWtU3d+I0sl+f2/LP3
wmhp/yYkYDYSTqE7ff2LVjavPcW/Xxbt6lusnu6bzJwOrLI9J198yyaQj7zo2NVX
SkV3Nr/gyK4wP/jmlv5DNSZeHDHMDZ2wONx4ir7s+gru45vrk5p1lu2nFyUFqaS4
pLsTMW85naNtUI6CaaRN1wu/eDGDTW6t5D8g8+Xhy9VsMpvVIgqHVzmpNkwpCFtQ
6KGGIlEQcik0R3apgvyLqEZo1ibm87hurWCyX4tXZT+h8ELw/97yx655Pu9Tb1Lh
2CsVlKECagtRJz0p5it53FShofBU6gd8HE1jr4aJ/tVzX5l+m3s8JXzA2+nOZZeP
7SyLMvmHVP7NDYSzq47Cy0ZlLE08klxYfJUbPnGqMOqa9R8ar9TTQW2+GKjEDnpe
ML4X2kev9FY+tLCpsoY5
=p5nS
-----END PGP SIGNATURE-----

--=-FBDcvPKDreM3Td6spHyU--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab3EOEmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 00:42:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19584 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3EOEmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 00:42:43 -0400
X-AuditID: cbfee690-b7efc6d000006d92-fc-5193124111a6
Message-id: <1368592895.11843.13.camel@kjgkr>
Subject: Re: [PATCH 2/2] f2fs: fix the inconsistent state of data pages
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 15 May 2013 13:41:35 +0900
In-reply-to: <CAKYAXd__Vy0g-w1wu9csq4P_NEcDDL7+A56K=ZtYtv0oKs9_qw@mail.gmail.com>
References: <1368575992-7142-1-git-send-email-jaegeuk.kim@samsung.com>
 <1368575992-7142-2-git-send-email-jaegeuk.kim@samsung.com>
 <CAKYAXd__Vy0g-w1wu9csq4P_NEcDDL7+A56K=ZtYtv0oKs9_qw@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-Od0/81z5tI+E4JjjyKCN"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t8zI11HocmBBvcusltcv3uL2eLSIneL
	PXtPslhc3jWHzYHFY+esu+weuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK6P3ygHmggnyFbPm
	zWZuYGyX6mLk5JAQMJF4vO84G4QtJnHh3nogm4tDSGAZo8TzndeZuhg5wIq+3K2CiC9ilLh6
	7B0jhPOaUWJdx1Z2kG5eAV2J74/+gNnCAu4Sdx/dYgZpZhPQlti83wAkLCSgKPF2/11WkLCI
	gJrEhGepIGFmgUyJOa8ng4VZBFQljs9RBwlzCgRLbJ26ngVi0ylGiW2rd4LdyS8gKnGy9RMj
	RG+VxK4tD5kh7leS2N3eCXWNoMSPyffAmiUE/rJLPN3VxgKSYBEQkPg2+RALxF+yEpsOQPVK
	ShxccYNlAqP4LCRjZyEZBRHXlGjd/psdwtaWWLbwNTOEbSuxbt17qBobiU1XFzBC2PIS29/O
	YV7AyL6KUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIyRuJ+xgvHfA+hBjFdCJE5mlRJPzgXGf
	VxJvaGxmZGFqYmpsZG5pRhVhJXFe9RbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mmi+u
	KW/Wb7xcGDvzy4/bjTvzUjc+XM7dmjLvxtplcX7pSZvZS+tUzu1vjl9ezqqf/fvgkldVf3pE
	tLhl9m/kCI9meSr6tm7Cn5jzRcf3pn5NfPRDSbG/7dVkG18prrVR+ks4M15/uv/r8738mJUd
	0oY9XHOCJZMmsFtZ/mI5qdX6PyD9mCi/EktxRqKhFnNRcSIAHr6HPggDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsVy+t9jAV1HocmBBjP+MFlcv3uL2eLSIneL
	PXtPslhc3jWHzYHFY+esu+weuxd8ZvL4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjGj98oB5oIJ8hWz5s1mbmBsl+pi5OCQEDCR+HK3qouRE8gUk7hwbz1bFyMX
	h5DAIkaJq8feMUI4rxkl1nVsZQep4hXQlfj+6A+YLSzgLnH30S1mkEFsAtoSm/cbgISFBBQl
	3u6/ywoSFhFQk5jwLBUkzCyQKTHn9WSwMIuAqsTxOeogYU6BYImtU9ezQGw6xSixbfVONpAE
	v4CoxMnWT4wQvVUSu7Y8ZIa4U0lid3sn1DWCEj8m32OZwCg4C0nZLCQpiLimROv23+wQtrbE
	soWvmSFsW4l1695D1dhIbLq6gBHClpfY/nYO8wJG9lWMoqkFyQXFSem5hnrFibnFpXnpesn5
	uZsYwUnhmdQOxpUNFocYBTgYlXh4CwInBQqxJpYVV+YeYlQBmvNow+oLjFIsefl5qUoivIbX
	gNK8KYmVValF+fFFpTmpxYcYJzICg2Mis5Rocj4wleWVxBsam5gZWRqZWRiZmJvTUlhJnPdA
	q3WgkEB6YklqdmpqQWoRzFFMHJxSDYwt1SwsnnPsX7oz/HS5mfjJU6lqv2BGA+elX5bT51m8
	3yJ8rT6u73Hqihv/b25znSAZbLr+5/p1x1yu3T6Y/695WpEL43TZydfa79mGH3WQUbrZ4tZ9
	Zt5MlsCNM38vSbeuNl0rGV/wKz0jcuO/G8xBUl3XX9RrNzOom5c/rFNZtCWl79irfX+VWIoz
	Eg21mIuKEwGNNGGDiQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Od0/81z5tI+E4JjjyKCN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-05-15 (=EC=88=98), 13:04 +0900, Namjae Jeon:
> 2013/5/15, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > In get_lock_data_page, if there is a data race between get_dnode_of_dat=
a
> > for
> > node and grab_cache_page for data, f2fs is able to face with the follow=
ing
> > BUG_ON(dn.data_blkaddr =3D=3D NEW_ADDR).
> >
> > kernel BUG at /home/zeus/f2fs_test/src/fs/f2fs/data.c:251!
> >  [<ffffffffa044966c>] get_lock_data_page+0x1ec/0x210 [f2fs]
> > Call Trace:
> >  [<ffffffffa043b089>] f2fs_readdir+0x89/0x210 [f2fs]
> >  [<ffffffff811a0920>] ? fillonedir+0x100/0x100
> >  [<ffffffff811a0920>] ? fillonedir+0x100/0x100
> >  [<ffffffff811a07f8>] vfs_readdir+0xb8/0xe0
> >  [<ffffffff811a0b4f>] sys_getdents+0x8f/0x110
> >  [<ffffffff816d7999>] system_call_fastpath+0x16/0x1b
> >
> > This bug is able to be occurred when the block address of the data bloc=
k is
> > changed after f2fs_put_dnode().
> > In order to avoid that, this patch fixes the lock order of node and dat=
a
> > blocks in which the node block lock is covered by the data block lock.
> >
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > ---
> >  fs/f2fs/data.c | 17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index 91ff93b..05fb5c6 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -233,18 +233,23 @@ struct page *get_lock_data_page(struct inode *ino=
de,
> > pgoff_t index)
> >  	struct page *page;
> >  	int err;
> >
> > +repeat:
> > +	page =3D grab_cache_page(mapping, index);
> > +	if (!page)
> > +		return ERR_PTR(-ENOMEM);
> > +
> >  	set_new_dnode(&dn, inode, NULL, NULL, 0);
> >  	err =3D get_dnode_of_data(&dn, index, LOOKUP_NODE);
> > -	if (err)
> > +	if (err) {
> > +		f2fs_put_page(page, 1);
> >  		return ERR_PTR(err);
> > +	}
> >  	f2fs_put_dnode(&dn);
> >
> > -	if (dn.data_blkaddr =3D=3D NULL_ADDR)
> > +	if (dn.data_blkaddr =3D=3D NULL_ADDR) {
> > +		f2fs_put_page(page, 1);
> >  		return ERR_PTR(-ENOENT);
> > -repeat:
> > -	page =3D grab_cache_page(mapping, index);
> > -	if (!page)
> > -		return ERR_PTR(-ENOMEM);
> > +	}
> >
> >  	if (PageUptodate(page))
> >  		return page;
> Is there no need to move PageUptodate condition checking to
> grab_cache_page next ?

For the data consistency, I'd like to check index in its node block
prior to this.
Thanks,

>=20
> Thanks.
> > --
> > 1.8.1.3.566.gaa39828
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >

--=20
Jaegeuk Kim
Samsung

--=-Od0/81z5tI+E4JjjyKCN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRkxH/AAoJEEAUqH6CSFDShn4P/0Xv0dIkhVoBuxr4MOAsadQo
zkcQZI5O+0Gr0vxWpjdxGncDnrVEs2ufHdO3ER5S/ILzlPp1mZVMZdNa9u86fUr0
bVAS++nqgXE84dAjjq9twt6oflaM51aJxTbsM51o9f2/IbacS9eGVHW1SfNOjMKA
0TsxbLyLJXlVDQyXc5ZB/BVcU+/kCwQ7OKs4xU5qTkYR5CucatuVZfCeB4OoZRDc
2qop2W85XhD5HV8IKHVV4U/8hKmzWk/vfDqw0x+K/sHf3Wbqywgy+Pz8Fw2H2uj6
JZk3JYSLuHt7R5aYtA3d+A0Katljl+R5Pq9+9CvfqiZkTalkcbKPEdk6hBFgK3G5
d2vMHqwISUho7ySiwXKJ8jLU+L8jbqDbPbL1F/myH2ClzxcdiVgjczcpVdW88wWT
bwkmiadquxqHDYIdvbO70RjtxwWsrawmvMf1mZEcFMKjeVeckvrneS45oC/gCYWS
f75+4i5Lwl3V0tR+ra5PQZUj5DTWd13Vt/PsUT7PlMS/aHApCtzHYFm+Zf+zdja+
fJn59VgfbTdvTcyVLe/mt8qbhnluQMn6Q4UnG79I6jJzPrGkddVV8YuOfXWWnE54
DGDlVSBAuGtBnpHaUBopBTHz/6OX0SWIYjFiITDql5XsD5RonsBedLrWSB4EGsRo
GNhVaQ2mUkqmq4B/luPv
=z7+5
-----END PGP SIGNATURE-----

--=-Od0/81z5tI+E4JjjyKCN--


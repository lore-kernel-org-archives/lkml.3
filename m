Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013Ab3CSHFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 03:05:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24229 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084Ab3CSHFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 03:05:15 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-b3-51480e1c68cb
Message-id: <1363676658.27362.3.camel@kjgkr>
Subject: Re: [PATCH] f2fs: reduce unncessary locking pages during read
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Changman Lee <cm224.lee@samsung.com>
Date: Tue, 19 Mar 2013 16:04:18 +0900
In-reply-to: <CAKYAXd9VawA5p+mWXdQUgq2rfNoYeRcj+zt0OM+k6eALCQjtcA@mail.gmail.com>
References: <1363585809-8138-1-git-send-email-jaegeuk.kim@samsung.com>
 <CAKYAXd9VawA5p+mWXdQUgq2rfNoYeRcj+zt0OM+k6eALCQjtcA@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-rzaBgy7WiFxLhofVZ5p2"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zY10ZPo9Ag4eXNC327D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLuLZrBWHBOtKL5dRtjA+MsoS5GTg4JAROJ3s6brBC2
	mMSFe+vZuhi5OIQEljFKbH/bx9TFyAFWdHRzBUR8EaPEuwXToYpeM0qsfvqdBaSbV0BH4t/k
	42C2sICbxKPVjxlBmtkEtCU27zcACQsJKEq83X+XFSQsIqAmMeFZKkiYWaCfUeLJDQWQMIuA
	qsSdxz4gJqdAsMSfM8oQi3oZJVZdX8oOUs4vICpxsvUTI0RrlcTmG4tZIM5Xktjd3skOcYyg
	xI/J91hAmiUE7rFLPNr+mAkkwSIgIPFt8iEWiLdkJTYdYIbolZQ4uOIGywRG8VlIxs5CMgoi
	rinRuv03O4StLbFs4WtmCNtWYt2691A1NhKbri5ghLDlgYE4h3kBI/sqRtHUguSC4qT0ImO9
	4sTc4tK8dL3k/NxNjJB47N/BePeA9SHGKqATJzJLiSbnA+M5ryTe0NjMyMLUxNTYyNzSjCrC
	SuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYD+pPucpQtMp5R564YEKyTjyD+OJ1
	jllyXAc/HvQpupe9YvfBOb3aS6KLdv89GJZ+Pr6nuUZVv2mpb2PCApfZN5Q+3k+/d7o2vKgm
	9Lmd4xRG32LpbzzPw5YcOMbfefpsVsx7i7n2k03TNP3P2jEvPzD7Q+dH7btXc50ULWq+BSZ8
	cnY8ZZ+nxFKckWioxVxUnAgAw2Gc6vQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jAV0ZPo9Agy13lC327D3JYnF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz7i2awVhwTrSi
	+XUbYwPjLKEuRg4OCQETiaObK7oYOYFMMYkL99azdTFycQgJLGKUeLdgOpTzmlFi9dPvLCBV
	vAI6Ev8mHwezhQXcJB6tfswIMohNQFti834DkLCQgKLE2/13WUHCIgJqEhOepYKEmQX6GSWe
	3FAACbMIqErceewDYnIKBEv8OaMMsaiXUWLV9aXsIOX8AqISJ1s/MUK0VklsvrGYBeJMJYnd
	7Z3sEMcISvyYfI9lAqPgLCRls5CkIOKaEq3bf7ND2NoSyxa+ZoawbSXWrXsPVWMjsenqAkYI
	W15i+9s5zAsY2VcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEf7M6kdjCsbLA4xCnAwKvHw
	ngh2DxRiTSwrrsw9xKgCNOfRhtUXGKVY8vLzUpVEeIP9gdK8KYmVValF+fFFpTmpxYcYJzIC
	Q2Mis5Rocj4wReWVxBsam5gZWRqZWRiZmJvTUlhJnPdAq3WgkEB6YklqdmpqQWoRzFFMHJxS
	DYzS7E8z3jfm7yq/6LS6lGfCDtawCyJtTZ49l/S2NhZXrHnsMV9b6XIUr6DmXX0Xze6m4jM8
	ia4NbA7zz89Md3mU+lmwfhbTxs8iRzNTVZ5LLl/xwyjk0tbmnBtepU9LJ15nPfHp9qb2fvXN
	5zfGp+TlSUdqP/vcGtT0cpriLDf2DT//PPrz55ESS3FGoqEWc1FxIgCvxKq1dQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rzaBgy7WiFxLhofVZ5p2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-03-19 (=ED=99=94), 13:54 +0900, Namjae Jeon:
> >
> > -	err =3D f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
> > -	if (err) {
> > -		f2fs_put_page(page, 1);
> > -		return ERR_PTR(err);
> > +	if (PageUptodate(page)) {
> > +		unlock_page(page);
> > +		return page;
> >  	}
> > -	unlock_page(page);
> Hi Jaegeuk.
> > +
> > +	err =3D f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
> > +	wait_on_page_locked(page);
> > +	if (!PageUptodate(page))
> > +		return ERR_PTR(-EIO);
> We don't need to release page before returning EIO ?

Good catch! :)

>=20
> >  	return page;
> >  }
> >
> > @@ -241,9 +244,13 @@ struct page *get_lock_data_page(struct inode *inod=
e,
> > pgoff_t index)
> >  	BUG_ON(dn.data_blkaddr =3D=3D NULL_ADDR);
> >
> >  	err =3D f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
> > -	if (err) {
> > -		f2fs_put_page(page, 1);
> > +	if (err)
> >  		return ERR_PTR(err);
> Here is also same. We don't need to release page in case of err ?

It's different.
The f2fs_readpage() releases the page if error is occurred.
Thanks,

>=20
> Thanks.
> > +
> > +	lock_page(page);
> > +	if (!PageUptodate(page)) {
> > +		f2fs_put_page(page, 1);
> > +		return ERR_PTR(-EIO);
> >  	}
> >  	return page;
> >  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Jaegeuk Kim
Samsung

--=-rzaBgy7WiFxLhofVZ5p2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRSA3yAAoJEEAUqH6CSFDSuhwP/A17ULo0WQQHRlxsDsjcFUhD
vTqJctXIU9YG+jMwH7GOH07+eFBKeOVL4XcneY73ENOhJzjIjEM9TL4xT2ecggYl
SqSgh5zOOGLq3drdDrs7YkZlTKH6BpIXRmmX9SyrHVSM206WhisQkE4/EJVRIlgT
oGrfpha4j86n6xB4B5Fok2Z4BrAx9+UN1o2hbbuhYh13CKBCAIbtZFlXZBChUeF7
mmr3RimodaiZRcg2mws69x/Nd1k0qz4IUwjuzSephr9+yMuisWS26O++Dck/4moI
4D87nxu8Dfy7QminU2mxlHKME2VrvkT/+2mcrI8YrEpNnxhP9A8J/TgYMb7xfVeB
ad6RWt1/EHo1IdsJXtk8E97I5yp5PbnreNM9FF40n3mwxJFBa/fZacFT3WqLiyWn
Vu8pMQ3eazzoxTWedIZ5DBkG6dQZPYrQVN+yt5AGqJzFonY9SizDZPNFuSmoMyqp
dqXWuqb5qTgcRTnJfjsc5rs5cx36ONsG8FMcxWedYJ7ZtepLy6NwZ4iPVZxHmgjC
wy33ZlGEFyQw4lfspdRorS3VBiOHHLpVDuonqjLi9LcGoPAIrXQZ/i3g+yndoRdX
zYqwfXWf6uzH9OUbvW0ey7LsE1PDwoRT7coMVjkeXOjqYDPm+KcUtDK06WlWMYCP
D6AhqQh9nMWMbid2b1ot
=EFHM
-----END PGP SIGNATURE-----

--=-rzaBgy7WiFxLhofVZ5p2--


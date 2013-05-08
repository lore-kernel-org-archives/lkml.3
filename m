Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3EHJvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 05:51:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22975 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab3EHJvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 05:51:08 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-ef-518a200aceca
Message-id: <1368006604.16581.64.camel@kjgkr>
Subject: Re: [PATCH 4/4] f2fs: optimize build_free_nids()
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 08 May 2013 18:50:04 +0900
In-reply-to: <20130508062455.GB8705@hli22-desktop>
References: <1367853344-28938-1-git-send-email-haicheng.li@linux.intel.com>
 <1367853344-28938-5-git-send-email-haicheng.li@linux.intel.com>
 <1367922839.16581.42.camel@kjgkr> <20130508062455.GB8705@hli22-desktop>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-FxnJ8iluf837Q/IpcjFx"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+ZoS6XQlegwactVhY3FpRZnHnWwWhx
	aZG7xZ69J1ksLu+aw+bA6rFz1l12j3knAz12L/jM5PF5k1wASxSXTUpqTmZZapG+XQJXxtVn
	21kKTktVTFl9nrmBcY1YFyMnh4SAiUTbyoXsELaYxIV769m6GLk4hASWMUr8OHmGCaaodfEG
	dojEIkaJB20bWCCc14wSr352sIBU8QroSkw695wRxBYWsJTYvPoNkM3BwSagLbF5vwFIWEhA
	UeLt/rusILYIUPnEt7OZQOYwC/QzSvzftwvsDBYBVYm+Oe9ZQXo5BYwknt3igNh1nVHiXNcV
	sF38AqISJ1s/ge1iFqiS2PT9HivEpUoSu9s72SHuEZT4Mfke2KESAp0cEkePdzBDLBCQ+Db5
	EAvIAgkBWYlNB5gheiUlDq64wTKBUXwWkrGzkIyCiGtKtG7/zQ5ha0ssW/iaGcK2lVi37j1U
	jY3EpqsLGCFseYntb+cwL2BkX8UomlqQXFCclF5kpFecmFtcmpeul5yfu4kREs19OxhvHrA+
	xFgFdOJEZinR5HxgMsgriTc0NjOyMDUxNTYytzSjirCSOK9ai3WgkEB6YklqdmpqQWpRfFFp
	TmrxIUYmDk6pBsb0jika9zqnPLsQbpRaFHaheEfxit0zGJZePfVk8mR142kM8y4pNS9cKnTm
	pdfdm4m/DoXvS2ddNfXY9LRXSqu8PjBsmrt3wwUH//Dyc7Mmlnr628imKmg3L/i349TiBwwc
	/3VsjSYe0jp1f+npkDlyXt8Mhfw9vPOC9nsoy+22avj8eHtqndlqJZbijERDLeai4kQA5QgW
	IxMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e+xgC6XQlegwatrJhY3FpRZnHnWwWhx
	aZG7xZ69J1ksLu+aw+bA6rFz1l12j3knAz12L/jM5PF5k1wAS1QDo01GamJKapFCal5yfkpm
	XrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0FYlhbLEnFKgUEBicbGSvh2mCaEh
	broWMI0Rur4hQXA9RgZoIGEdY8bVZ9tZCk5LVUxZfZ65gXGNWBcjJ4eEgIlE6+IN7BC2mMSF
	e+vZuhi5OIQEFjFKPGjbwALhvGaUePWzgwWkildAV2LSueeMILawgKXE5tVvgGwODjYBbYnN
	+w1AwkICihJv999lBbFFgMonvp3NBDKHWaCfUeL/vl1g21gEVCX65rxnBenlFDCSeHaLA2LX
	dUaJc11XwHbxC4hKnGz9BLaLWaBKYtP3e6wQlypJ7G7vZIe4R1Dix+R7LBMYBWchKZuFJAUR
	15Ro3f6bHcLWlli28DUzhG0rsW7de6gaG4lNVxcwQtjyEtvfzmFewMi+ilE0tSC5oDgpPddQ
	rzgxt7g0L10vOT93EyM4VTyT2sG4ssHiEKMAB6MSD68Fd2egEGtiWXFl7iFGFaA5jzasvsAo
	xZKXn5eqJMIr8BAozZuSWFmVWpQfX1Sak1p8iHEiIzA4JjJLiSbnAxNcXkm8obGJmZGlkZmF
	kYm5OS2FlcR5D7RaBwoJpCeWpGanphakFsEcxcTBKdXAuNqJqXmOtovixyDHiDT7E+eW1r94
	nhTw9OnPm9NXR6rGbZxg5JdesPJCkcLu9RnB9auZWhYr5S3PmWx4aFvL184S9mvhp7uMv2WY
	H1RvnZXP+/LwBcUL/NazXCdMuta38966cvYpZywP79BbcbxK22Zr8erLQmpOU7QEHgiavX2q
	/0Mp2s3fRYmlOCPRUIu5qDgRALOvv8KUAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FxnJ8iluf837Q/IpcjFx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-05-08 (=EC=88=98), 14:24 +0800, Haicheng Li:
> On Tue, May 07, 2013 at 07:33:59PM +0900, Jaegeuk Kim wrote:
> > 2013-05-06 (=EC=9B=94), 23:15 +0800, Haicheng Li:
> > > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > > index 1fe3fe2..3136224 100644
> > > --- a/fs/f2fs/node.c
> > > +++ b/fs/f2fs/node.c
> > > @@ -1342,6 +1342,8 @@ static void build_free_nids(struct f2fs_sb_info=
 *sbi)
> > >  		if (nid >=3D nm_i->max_nid)
> > >  			nid =3D 0;
> > > =20
> > > +		if (nm_i->fcnt > 2 * MAX_FREE_NIDS)
> > > +			break;
> >=20
> > Could you explain when this can happen?
>=20
> I'm thinking of this possible scenario:
>=20
> as we don't hold any spinlock to protect the context, add_free_nid() coul=
d be=20
> called by other thread anytime, e.g. by the gc_thread_func() in backgroun=
d.

The gc_thread_func() is not a proper example here though, the
buid_free_nids() is covered by nm_i->build_lock, so build_free_nids is
entered only one at a time.
In addtion, build_free_nids starts with checking if (nm_i->fcnt >
NAT_ENTRY_PER_BLOCK) in order not to be conducted repeatedely.

>=20
> then nm_i->fcnt could be increased as 2 * MAX_FREE_NIDS while i < FREE_NI=
D_PAGES.
> Anything I misconsidered?

Apart from the correctness of this behavior, I'm not sure why we should
strictly manage this threshold value.
Should we really need to do this?

>=20
> > IMO, this is an unnecessary condition check, since the below condition
> > that includes FREE_NID_PAGES already limits the number of free nids.
> > Thanks,
>=20
> hmm, the pros is that this check may possibly avoid some (< 4) unnecessar=
y while-loop,
> the cons is that too many checks of (nm_i->fcnt > 2 * MAX_FREE_NIDS)
> would make the code looking messy and fragmentary...
> =20
> > >  		if (i++ =3D=3D FREE_NID_PAGES)
> > >  			break;
> > >  	}
> >=20
> > --=20
> > Jaegeuk Kim
> > Samsung
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Jaegeuk Kim
Samsung

--=-FxnJ8iluf837Q/IpcjFx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRih/MAAoJEEAUqH6CSFDSvU8P/0EJC99JpN+D0IKuwjSmd4ap
uQPIX1z+nb5V7WjNc/RT8vB94Fa4OakjD98TIcE/N2BiqNolM40uoUQ4Pkze3gd9
vHxs6rT6U5E93gI1ceQE8hzcUwzZ8vcwfPndJUd/5cQGUADpMrhRG0KUS+yKzkYe
MAaPYOnIPFK39DqffxdzZa8A6SWyWN96UH9p+NcvDkiDEnDGRazJMJihPPbbnfgf
xHUFBERKnlDYzfwgQZJGx4J6/NFz+03ToqZtCpDfR4MkrtHXy+lNcCmVp6+ndZag
9BkrvNBdK+Q1H5MQWeiKrC4p+Pv6M5WM1fHl/Am+EfsWKAUg7D5x57TFzomBuoES
nKrd17J5l9OWXuCSPPMhW/Nq2velEcH9ScMIINy0qVtSh83FMRuq1+zCyliqdJkU
E8pTTU6oY476tGs/nGOxg1wmoNVqDcLwlj6h+UqVvy5fX/5JNzfsmVfwr8Xcg+1O
t1Uc6mzuo9kkYtSGA1YnngNHFH5EAYIl7XYJ+rcIVaPlnx5ctSmEJZiqpBYmua+B
gu6oSNR2+f3KVpw/BOmLDBjwViq23Tu+cV5ujr8NJVq97yinatz7xfLE8ejeXnOB
xsIriRyX+Ie0O89c7dK0mkO9YsdAA0U2uEhcqCzgOyw9j2X92XYbZDM0jxyE1Dni
ZY74Lqh1+Ade0uX3NtHx
=5iEr
-----END PGP SIGNATURE-----

--=-FxnJ8iluf837Q/IpcjFx--


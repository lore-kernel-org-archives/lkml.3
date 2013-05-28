Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab3E1Bfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 21:35:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10648 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758356Ab3E1Bfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 21:35:43 -0400
X-AuditID: cbfee68f-b7f436d000000f81-55-51a409eb6257
Message-id: <1369704867.10521.46.camel@kjgkr>
Subject: Re: [PATCH 2/2] f2fs: add sysfs support for controlling the gc_thread
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Date: Tue, 28 May 2013 10:34:27 +0900
In-reply-to: <CAKYAXd_QZronHD536LOfeFWLmtCoweRq3gbH94R4_7oKC7hv3w@mail.gmail.com>
References: <1369533945-6955-1-git-send-email-linkinjeon@gmail.com>
 <1369619214.10521.25.camel@kjgkr>
 <CAKYAXd_QZronHD536LOfeFWLmtCoweRq3gbH94R4_7oKC7hv3w@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-+QrFJcKhcSoQM45hooja"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+Zge5rziWBBofuiFpcv3uL2eLSIneL
	PXtPslhc3jWHzeLH9HqLH7vOMzuweeycdZfdY/eCz0wefVtWMXp83iQXwBLFZZOSmpNZllqk
	b5fAlTFj8lvWgjalivPPf7M1ME6X6WLk5JAQMJH4eekiE4QtJnHh3nq2LkYuDiGBZYwS+y7e
	Z4UpejPrHjtEYjqjxOerG6Cc14wSGzdeYQap4hXQlTj1YDI7iC0s4CcxccIvoDgHB5uAtsTm
	/QYgYSEBRYm3+++ygoRFBNQkJjxLBQkzC+xglGg6aA5iswioSrSv2g1WwikQLLFwrzdE5zpG
	iSM3MkBsfgFRiZOtnxghWqskOl/fZIc4U0lid3snO8QxghI/Jt9jAblSQqCXQ2LLzjdMEPMF
	JL5NPsQCMl9CQFZi0wFmiF5JiYMrbrBMYBSfhWTsLCSjIOKaEq3bf7ND2NoSyxa+ZoawbSXW
	rXsPVWMjsenqAkYIW15i+9s5zAsY2VcxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525ihMR0/w7G
	uwesDzFWAZ04kVlKNDkfmBLySuINjc2MLExNTI2NzC3NqCKsJM6r1mIdKCSQnliSmp2aWpBa
	FF9UmpNafIiRiYNTqoGxYVMtv5F02tWzKx4dCF9YdLt+WRfDT6uKKQbH6ha3rk0+XHOsOVM2
	qOyKl4xQ6cSShphL0slTDm1b3Li16Ly65oWTBYprA5UVOeKuv9n7QV3cf/9v5kemM7ZFJO9L
	ezk1/uHZr31xXPF367zeWTIY6NwxWqGbmOGyKnnzR882vp+yR77JTjVWYinOSDTUYi4qTgQA
	uVsw7xYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42I5/e+xoO5rziWBBrNvClhcv3uL2eLSIneL
	PXtPslhc3jWHzeLH9HqLH7vOMzuweeycdZfdY/eCz0wefVtWMXp83iQXwBLVwGiTkZqYklqk
	kJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RbSaEsMacUKBSQWFys
	pG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5gxY/Jb1oI2pYrzz3+zNTBOl+li5OSQEDCReDPr
	HjuELSZx4d56ti5GLg4hgemMEp+vbmCHcF4zSmzceIUZpIpXQFfi1IPJYB3CAn4SEyf8Aopz
	cLAJaEts3m8AEhYSUJR4u/8uK0hYREBNYsKzVJAws8AORommg+YgNouAqkT7qt1gJZwCwRIL
	93pDdK5jlDhyIwPE5hcQlTjZ+okRorVKovP1TagzlSR2t3eyQxwjKPFj8j2WCYyCs5CUzUKS
	gohrSrRu/80OYWtLLFv4mhnCtpVYt+49VI2NxKarCxghbHmJ7W/nMC9gZF/FKJpakFxQnJSe
	a6RXnJhbXJqXrpecn7uJEZwwnknvYFzVYHGIUYCDUYmHd0L24kAh1sSy4srcQ4wqQHMebVh9
	gVGKJS8/L1VJhHf7CqA0b0piZVVqUX58UWlOavEhxomMwNCYyCwlmpwPTHN5JfGGxiZmRpZG
	ZhZGJubmtBRWEuc92GodKCSQnliSmp2aWpBaBHMUEwenVAOj3bWZF1u3x3h1TBFuzRew/nW+
	MX1X5JRD77mfa9ttmlLYUSghnF782KPtxSNGV8apPBeLGr6J3/h8ePEW/wSzghLOrOcnH/ZG
	ApPLn4fp915MWb6dzeqt0aVN4QX93vydWSlzjuy7oHTjha6jklxIUOXTPT7FR9dFyWocWnlx
	1pXEwzNlF8UpsRRnJBpqMRcVJwIAHMhn85cDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+QrFJcKhcSoQM45hooja
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

2013-05-27 (=EC=9B=94), 13:45 +0900, Namjae Jeon:
> 2013/5/27, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > Hi Namjae,
> Hi Jaegeuk.
>=20
> First, Thanks for your interest.
> >
> > This is an interesting functionality.
> > Could you describe why and when we need to do this?
> > What are pros and cons?
> > How can we use this?
> As the default size of the F2FS parameter can vary as per the storage
> size, so we can figure out the default values for Garbage collection
> on each device.
> It will be good if we can provide an interface which helps in tunning
> these timing parameters to optimize the behavior of GC thread.

Agreed.

>=20
> As you know, we can see performance dropping suddenly by GC thread. GC
> thread is working more roughly for big size disk. And on other hand,
> it is more work hard for very small partition.
>=20
> And If App didn't access f2fs partition for a while. We can use this
> time to make possible valid blocks using foregound gc thread working.
> So we should need gc thread fg start and stop functionality.
> We will describe how to use it and more detail in patch changelog(v2).
> >
> > IMO, when users try to control IO latencies, it seems that they can
> > trigger such the explicit GCs, but in order to do that, they also need
> > to know the status of current f2fs in more precisely. Does the debugfs
> > show it enoughly?
> First important thing before running the GC thread forecefully from
> the user level =E2=80=98sysfs=E2=80=99 is to have diagnostic values of th=
e FLASH
> partition. So, we are trying to figure out how we can check the stats
> regarding running the GC thread.
>=20
> I have thought more after getting your reply.
> f2fs_cleaner(a tentative name) is that provide the following several
> options to control gc thread.
> 1. start forground gc thread to clean all invalid blocks.
> 2. stop number 1(fg) working.
> 3. set new tunning parameter (min/max/no_gc).
> 4. get status of current f2fs.
> We will provide user level util in f2fs tools and sysfs at the same time.
> It is useful if the console level user/App user can change them easily.
>=20
> >
> > Afterwards, it is worth to add some information to
> > Document/filesystems/f2fs.txt.
> Yes, It will be included in next series patches.
> How do you think ? If you agree my suggestion, I will start to work
> the above jobs.

As I described, basically I agreed that this kind of interfaces and user
apps are definitely beneficial to the f2fs users.

But wrt design and implementation of new interfaces, we'd better discuss
how to use them in more detail and what information should be needed for
user-made cleaner.
After then, we'd better start to design the interfaces as well as user
scenarios clearly.

IMO, the following issues should be addressed.
- how to know system idle time by users?
- any priority scheme for cleaning?
- what status of current f2fs?
- how about supporting that f2fs controls gc times dynamically instead
of the user decision?

Thanks,

>=20
> Let me know your opinion.
>=20
> Thanks.
> >
> > Thanks,
> >

--=20
Jaegeuk Kim
Samsung

--=-+QrFJcKhcSoQM45hooja
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRpAmjAAoJEEAUqH6CSFDSWUwP/2DbVKxhzQysNexbNgrYp6xK
VvAq8TEj05nSHyQlmhFtr+9ytXwJ0e5StkuQ1SCKZ2wKCeMAnbt76wFRZo2lHiQB
SiopzSO/p8BcEHikOcinqL2FRNFDRu/uyXtzWKa63lFBZnb2GOjx3HAcb1zNzPiy
1iJd0NSNfO4d75H7LJXFaMGxS+eGHzVR6YFpFazD3ccy1dEgUbAxs2EMfzpPrU+1
0xZdgx7puu4vmzaI6XelFDPUu0KxKSdn/4NrFX3BTT0zD3WG4dd2XfhmLUNqnlQz
7SlAfFP6NCneQMdtWpXAkErMky4+zmyZhbM9ATm2oBSazDP/B2EJS/hwR/NQV++d
WEu3MLWY4oAVy7vS5DTJIXI9cmhd0ttWrQPr6WpdhdPznCoEVQ+g99pLM3gDCdgc
fBDo6MxHvA19AOR8akSBp0K+MIdHldOe3MK4rqYFBApehl8/QDyFkrVEnQut8KrZ
0m5Xt6z2K2DWayCJwcINwTZsraMkllj5mEPMqx+zBCg7Qw0VEg9JD/qk60EsxYYe
gZ8Y9sQgwOeGQoyMchIvPp7M6KJLG0vg4DuNl2lQbFscjwwJmqHQ3RNKeuQ10gQf
lBZvC/ggEuiy8Lfmpx6ToiLqRhTBCHCu5LdWbup58BL1dAqGsejImhe8tU4/mOa9
Z6oP2NR4cJnG57/IPs8X
=hyi9
-----END PGP SIGNATURE-----

--=-+QrFJcKhcSoQM45hooja--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab3FEHOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:14:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13369 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab3FEHOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:14:51 -0400
X-AuditID: cbfee68f-b7f436d000000f81-52-51aee569e19c
Message-id: <1370416414.3600.36.camel@kjgkr>
Subject: Re: [RFC 0/5] Enable f2fs support inline data
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, Huajun Li <huajun.li@intel.com>,
        linux-fsdevel@vger.kernel.org, huajun.li.lee@gmail.com,
        namjae.jeon@samsung.com, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 05 Jun 2013 16:13:34 +0900
In-reply-to: <20130604060119.GA3265@hli22-desktop>
References: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
 <1370312366.3600.3.camel@kjgkr>
 <CAKYAXd-87rGatnEC8wbocR_wt6Qdpec3HzZaH9ukpzmst6DK=A@mail.gmail.com>
 <20130604060119.GA3265@hli22-desktop>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-pgFXLHbwhUk4xr7kVXWL"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t8zY93Mp+sCDX5slbI486yD0WLLlhiL
	r/132Cyu373FbHFpkbvFnr0nWSwu75rDZvFjer0Dh8fOWXfZPRbvecnkMe9koMfuBZ+ZPPq2
	rGL0+LxJLoAtissmJTUnsyy1SN8ugSujf/pSxoKNBhVPFzxka2DcpNbFyMkhIWAiMfVbGyOE
	LSZx4d56ti5GLg4hgWWMElev3GaGKZrUf54VIrGIUeLWognMEM5rRomZJ1tZQKp4BXQkjp3p
	A0pwcAgLmEm09GeBmGwC2hKb9xuAVAgJKEq83X+XFcQWEdCVmPh2NhPIGGaBJ4wSX5YuAxvD
	IqAq0XtnP9hiTgEjiYkP1zNB7LrCKNHw6BpYEb+AqMTJ1k+MIAuYBaokZn1IhThUSWJ3eyc7
	xDmCEj8m32MB6ZUQWMshMenoZlaIBQIS3yYfYgHplRCQldh0AOpJSYmDK26wTGAUn4UwdRaS
	SSA2s4CmROv23+wQtrbEsoWvmSFsW4l1695D1dhIbLq6gBHClpfY/nYO8wJG9lWMoqkFyQXF
	SelFxnrFibnFpXnpesn5uZsYIZHfv4Px7gHrQ4xVQBdOZJYSTc4HJo68knhDYzMjC1MTU2Mj
	c0szqggrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamC00Ep629oYpbDbcqmF2U3F
	xzYrnI3m7mdW8PF5LVO55X3007bfi2qmzDsvlJ4z0Uhx3utNLYJ2fSYnEkvW33XU8+1b4Tt3
	CaN8RJmwGcMC0cOrfpVWr9my+bzlrS2n188OsBfcskr91lY5LsYjXCZaS5nScq6kaYhdtLt+
	pm5OTkLFj38qapeUWIozEg21mIuKEwELsWrSKQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsVy+t9jAd3Mp+sCDa7PEbE486yD0WLLlhiL
	r/132Cyu373FbHFpkbvFnr0nWSwu75rDZvFjer0Dh8fOWXfZPRbvecnkMe9koMfuBZ+ZPPq2
	rGL0+LxJLoAtqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUn
	QNctMwfoGiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRv/0pYwFGw0q
	ni54yNbAuEmti5GTQ0LARGJS/3lWCFtM4sK99WxdjFwcQgKLGCVuLZrADOG8ZpSYebKVBaSK
	V0BH4tiZPqAEB4ewgJlES38WiMkmoC2xeb8BSIWQgKLE2/13wWaKCOhKTHw7mwlkDLPAE0aJ
	L0uXgY1hEVCV6L2znxnE5hQwkpj4cD0TxK4rjBINj66BFfELiEqcbP3ECLKAWaBKYtaHVIhD
	lSR2t3eyQ5wjKPFj8j2WCYyCsxCqZiHJgNjMApoSrdt/s0PY2hLLFr5mhrBtJdatew9VYyOx
	6eoCRghbXmL72znMCxjZVzGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEp5VnUjsYVzZYHGIU
	4GBU4uH9wLAuUIg1say4MvcQowrQnEcbVl9glGLJy89LVRLhDU0ASvOmJFZWpRblxxeV5qQW
	H2KcyAgMjYnMUqLJ+cBkmFcSb2hsYmZkaWRmYWRibk5LYSVx3gOt1oFCAumJJanZqakFqUUw
	RzFxcEo1MMY05HM4M4ptexnG+jGQ8cp1/bxEheJzd6fpXc1ZeoN9NpdxaJjvfHXWDSxG/Lbt
	prOZVlbzybe53TMSy746sePnIYsf9d0b7stz+7b7Vy6S3xmzW975vO0F2T2LSsLme7ouFHix
	8te1p0ubNLd4755aoB699GJa3cdwu1mx3i1L/Ng+Fn7zVGIpzkg01GIuKk4EAFvOcCCqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pgFXLHbwhUk4xr7kVXWL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Haicheng,

2013-06-04 (=ED=99=94), 14:01 +0800, Haicheng Li:
> Hi Jaegeuk & Namjae,
>=20
> Sure, we'll address your comments. And this version is RFC, just wanna to
> make sure this feature is meaningful for f2fs project, and there is no ob=
vious
> mistake, e.g. missing some critical path.

IMO, it is worth to design and implement the inline feature though, I'd
like to review the total design before looking at trivial mistakes.
Since if the initial design is changed frequently, we need to review
again and again.

So, we need to decide the overall inline design.
Currently we have to consider three data structures at a same time for
the on-disk *inline* inode block structure, which are data, dentry, and
xattr as well.

IMO, we can give three inode flags: F2FS_INLINE_DATA, F2FS_INLINE_DENT,
and F2FS_INLINE_XATTR.

< on-disk inode block >
 - metadata
 - if F2FS_INLINE_XATTR is set,
  : use fixed 2*255 bytes to *cache* two xattrs for simplicity
 `- if F2FS_INLINE_DATA is set,
   : use the remained space varied by F2FS_INLINE_XATTR.
 `- if F2FS_INLINE_DENT is set,
   : use variable number of dentries determined by F2FS_INLINE_XATTR.
 `- Otherwise, use as pointers

And then, we need to define how to deal with their combinations.

Operational conditions
----------------------
 - use inline xattr or not, by checking other inline flags and inline
data size.
 - calculate inline data size and its offset according to the use of
inline xattrs.
 - the places of inline operaions wrt the lock consistency and coverage
 - Power-off-recovery routine should care about the on-disk inode
structure.
 - unset F2FS_INLINE_DATA if i_size =3D 0
 - unset F2FS_INLINE_XATTR if xattr entries =3D 0
 - unset F2FS_INLINE_DENT if dentries =3D 0

 - what else?

Once we design the whole thing, we can make general functions to deal
with them gracefully.

> And if you team has some special opensource test suites used in your dail=
y
> f2fs test cycle, pls. kindly share the info with us, then we can make sur=
e our
> patchset can pass these cases before we send out next version.

1. xfstests for functionality
2. fsstress for deadlock/consistency check
3. power-off with fsstress

Thanks,

> BTW, test the kernel source tree or kernel build is a good suggestion. th=
anks.
>=20
> On Tue, Jun 04, 2013 at 01:23:57PM +0900, Namjae Jeon wrote:
> > Hi. Huajun.
> >=20
> > I agree jaegeuk's opinion.
> > Additionally, It is better that you describe the effect in change-log
> > when this feature is added to f2fs.
> > e.g.
> >     1. how much space is saved when storing kernel-tree(small files) ?
> >     2. small files creation performance test.
> >     3. file look-up performance test.
> >     4. other performance tools 's result.
> >=20
> > Thanks.
> >=20
> > 2013/6/4 Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > > Hi,
> > >
> > > This feature is one of my todo items. ;)
> > > Thank you for the contribution.
> > >
> > > Before reviewing the below code intensively, we need to check the
> > > following issues.
> > >
> > > - deadlock conditions
> > > - FS consistency
> > > - recovery routine
> > >
> > > Could you check one more time?
> > > Thanks again,
> > >
> > > 2013-06-03 (=EC=9B=94), 18:04 +0800, Huajun Li:
> > >> f2fs inode is so large, small files can be stored directly in the in=
ode,
> > >> rather than just storing a single block address and storing the data=
 elsewhere.
> > >>
> > >> This RFC patch set is just to enable f2fs support inline data: files=
 less than
> > >> about 3.6K can be stored directly in inode block.
> > >>
> > >> TODO: make small dirs inline too.
> > >>
> > >>
> > >> Haicheng Li (3):
> > >>   f2fs: Add helper functions and flag to support inline data
> > >>   f2fs: Add interface for inline data support
> > >>   f2fs: add tracepoints to debug inline data operations
> > >>
> > >> Huajun Li (2):
> > >>   f2fs: Handle inline data read and write
> > >>   f2fs: Key functions to handle inline data
> > >>
> > >>  fs/f2fs/Kconfig             |   10 +++
> > >>  fs/f2fs/Makefile            |    1 +
> > >>  fs/f2fs/data.c              |   78 +++++++++++++++++++++-
> > >>  fs/f2fs/f2fs.h              |   70 +++++++++++++++++++
> > >>  fs/f2fs/file.c              |    9 ++-
> > >>  fs/f2fs/inline.c            |  156 ++++++++++++++++++++++++++++++++=
+++++++++++
> > >>  fs/f2fs/inode.c             |    8 +++
> > >>  include/linux/f2fs_fs.h     |    5 ++
> > >>  include/trace/events/f2fs.h |   69 +++++++++++++++++++
> > >>  9 files changed, 402 insertions(+), 4 deletions(-)
> > >>  create mode 100644 fs/f2fs/inline.c
> > >>
> > >
> > > --
> > > Jaegeuk Kim
> > > Samsung
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Jaegeuk Kim
Samsung

--=-pgFXLHbwhUk4xr7kVXWL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRruUeAAoJEEAUqH6CSFDS6PMP/ih3KAKfvnSNuoHdux33XQyl
eJYQnFulENarOOeHeOkyqnSUVKC5BL/9INY5vQduKKCODiDDlA5bzqCVPEmKvD4A
Ec1SudKd4HYgAwKn9MAw/UMwDuoZifSapjQACGIaaXUFK5/QnjWNiLiWcr7xoO14
LAB0GNs1bt3CGR5JrFuWv9QHvn/u+eR8HUUt955aYiyFOg2m3nJvhzkSFmgzdKz2
q3POj2E8KQOeej4rdXBvrXtxl4X9EPh2Tt1ZThK8BojUxixgEQw3eWC1RVjbQ4wq
+nXvEmP7P6cvTAAyzj1dNXeUYyX0t1Xo6Bbz9AbEiQHl4MVTfT2O0HUFqS2CdkRD
90VnbkRHwjIpguXkYQ0yUHbvvvF6IxZsSroQhFzQS4i5Q802HtQYKP4mGndAXIwg
3I33ckwXB/wozXXCAmwDxvWgOfnaIfYZd8Ab3ASI6l0TovSESFwXkLNP2YnEwmB9
4q9OjATp0DUvRRGd1fzX1N52fKEpXm64DoFJNw5ee4Qzz7dp9GvCi9tbHl4SK/7i
NAve6s8J0qXTETcb3ZlYeu2Td5RN7oSmTNvzH1E9Kt3QC6fep5VA/mLJKEoHyCYW
F8UfPd8kFgaS/0a9YZjqvEWQ0tVKf0kr3k3XJRaIH4PRtKPPTNCs1nMcI1F2h4Yt
F7r2Jylm7Kj5d2dzNhu8
=f46L
-----END PGP SIGNATURE-----

--=-pgFXLHbwhUk4xr7kVXWL--


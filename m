Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3BEHN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 02:13:27 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:24035 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3BEHNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 02:13:24 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-d3-5110b112976a
Message-id: <1360048376.26950.34.camel@kjgkr>
Subject: Re: [PATCH] f2fs: add compat_ioctl to provide backward compatability
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Tue, 05 Feb 2013 16:12:56 +0900
In-reply-to: <CAKYAXd8Qo44D8sNo8+r21fmV2ZQinSbqk8WmNiip+vgh9Wo6ow@mail.gmail.com>
References: <1359988901-7384-1-git-send-email-linkinjeon@gmail.com>
 <CAKYAXd8QsGzz0FHUNZfBt7kskPQprVrTQcuag75oxx09_R22Ow@mail.gmail.com>
 <1360046719.26950.26.camel@kjgkr>
 <CAKYAXd8Qo44D8sNo8+r21fmV2ZQinSbqk8WmNiip+vgh9Wo6ow@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-qISzmLpL4A7FDB+xA2sf"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t8zA12hjQKBBs/2GVjs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWcvfGZteCwdsW/u80sDYwflLoYOTkkBEwkvjbvYoGw
	xSQu3FvP1sXIxSEksIxR4sbCjewwRY23P7BDJBYxSuz7+4MRwnnNKHF7+XpWkCpeAV2JWVNv
	MoPYwgK+El9X9gAVcXCwCWhLbN5vABIWElCUeLv/LitIWERATWLCs1SQMcwCuxgljh1dAnYF
	i4CqxPy779lAbE6BYInFnc+gFn9llNi85BojSIJfQFTiZOsnMJtZoEridt81VohLlSR2t3ey
	Q9wjKPFj8j0WkGYJgZfsEt+fL2SF2CAg8W3yIRaQKyQEZCU2HWCG6JWUOLjiBssERvFZSMbO
	QjIKIq4p0br9NzuErS2xbOFrZgjbVmLduvdQNTYSm64uYISw5SW2v53DvICRfRWjaGpBckFx
	UnqukV5xYm5xaV66XnJ+7iZGSFxK72Bc1WBxiFGAg1GJh/fHZf5AIdbEsuLK3EOMKkBzHm1Y
	fYFRiiUvPy9VSYT34w2gNG9KYmVValF+fFFpTmrxIcYqoOcmMkuJJucDU0leSbyhsbGJmYmp
	ibmlqbkpVYSVxHkZTz0JEBJITyxJzU5NLUgtglnOxMEp1cCYefZdZdFZ26Vrvtw9IHtHqzHW
	c37o38DMZ29ET3zK+tmaHqbnUPZkac2P1U3zJswUEwgWSnKa0CL2PaiYsaQhruzbPhGbNXEM
	nd2PdJtXLjlrGFh6ZN7fNKNDaYasEm+T+JvjJSNKyqrk5fa8/7CgQNrljLjHqUw3geKPixZs
	fBPCy6tSs1+JpTgj0VCLuag4EQAxS5MeMgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGKsWRmVeSWpSXmKPExsVy+t9jAV2hjQKBBic+q1vs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmnL3xmbXgsHbF
	v7vNLA2MH5S6GDk5JARMJBpvf2CHsMUkLtxbz9bFyMUhJLCIUWLf3x+MEM5rRonby9ezglTx
	CuhKzJp6kxnEFhbwlfi6sgeoiIODTUBbYvN+A5CwkICixNv9d1lBwiICahITnqWCjGEW2MUo
	cezoEhaQGhYBVYn5d9+zgdicAsESizufsUPs+soosXnJNUaQBL+AqMTJ1k9gNrNAlcTtvmus
	EJcqSexu72SHuEdQ4sfkeywTGAVnISmbhSQFEdeUaN3+mx3C1pZYtvA1M4RtK7Fu3XuoGhuJ
	TVcXMELY8hLb385hXsDIvopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOOqfSe9gXNVgcYhR
	gINRiYf3x2X+QCHWxLLiytxDjCpAcx5tWH2BUYolLz8vVUmE9+MNoDRvSmJlVWpRfnxRaU5q
	8SHGiYzA8JjILCWanA9MVXkl8YbGJmZGlkZmFkYm5ua0FFYS52U89SRASCA9sSQ1OzW1ILUI
	5igmDk6pBkZ34VmueXNY26U9SxSuqKr5TnoT/Mf0YvBlpisZyltfzdZYI7Zum9st3a1JH0v7
	3nXM3/jVZuaZQ6fXcOSYXjzx/cz64IOiu6KUd7twnVi7tcJi+vGb3dee9msu8F0bPG/mzbvZ
	E7y4ajlU7rj+jFRrP7w1s8zomEdc7MqFr++m3Hy8akXFPv3DSizFGYmGWsxFxYkAr7xNx3kD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qISzmLpL4A7FDB+xA2sf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-02-05 (=ED=99=94), 16:02 +0900, Namjae Jeon:
> 2013/2/5, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > Hi,
> >
> > 2013-02-05 (=ED=99=94), 14:28 +0900, Namjae Jeon:
> >> Hi Jaegeuk.
> >>
> >> Oops!, I was missing include header.
> >> Sorry, I will send v2 patch again.
> >
> > I got a build error, and simply added the following header file in your
> > patch.
> >
> > #include <linux/compat.h>
> >
> > Is it correct?
> Yes, Right :) It should be needed.
> Sorry for my mistake again. Could you add this header instead of me
> ?(because I can resend the patch tonight....).

No problem. I've already done it. :)
Thanks,

>=20
> Thanks!
> >
> > Thanks,
> >
> >>
> >> Thanks.
> >>
> >> 2013/2/4, Namjae Jeon <linkinjeon@gmail.com>:
> >> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >> >
> >> > adding compat_ioctl to provide support for backward comptability -
> >> > 32bit
> >> > binary
> >> > execution on 64bit kernel.
> >> >
> >> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> >> > Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> >> > ---
> >> >  fs/f2fs/f2fs.h |   15 +++++++++++++++
> >> >  fs/f2fs/file.c |   20 ++++++++++++++++++++
> >> >  2 files changed, 35 insertions(+)
> >> >
> >> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> >> > index 58dd608..7bf86c8 100644
> >> > --- a/fs/f2fs/f2fs.h
> >> > +++ b/fs/f2fs/f2fs.h
> >> > @@ -104,6 +104,20 @@ static inline int update_sits_in_cursum(struct
> >> > f2fs_summary_block *rs, int i)
> >> >  }
> >> >
> >> >  /*
> >> > + * ioctl commands
> >> > + */
> >> > +#define F2FS_IOC_GETFLAGS               FS_IOC_GETFLAGS
> >> > +#define F2FS_IOC_SETFLAGS               FS_IOC_SETFLAGS
> >> > +
> >> > +#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
> >> > +/*
> >> > + * ioctl commands in 32 bit emulation
> >> > + */
> >> > +#define F2FS_IOC32_GETFLAGS             FS_IOC32_GETFLAGS
> >> > +#define F2FS_IOC32_SETFLAGS             FS_IOC32_SETFLAGS
> >> > +#endif
> >> > +
> >> > +/*
> >> >   * For INODE and NODE manager
> >> >   */
> >> >  #define XATTR_NODE_OFFSET	(-1)	/*
> >> > @@ -850,6 +864,7 @@ void f2fs_truncate(struct inode *);
> >> >  int f2fs_setattr(struct dentry *, struct iattr *);
> >> >  int truncate_hole(struct inode *, pgoff_t, pgoff_t);
> >> >  long f2fs_ioctl(struct file *, unsigned int, unsigned long);
> >> > +long f2fs_compat_ioctl(struct file *, unsigned int, unsigned long);
> >> >
> >> >  /*
> >> >   * inode.c
> >> > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> >> > index 633667e..e79d26a 100644
> >> > --- a/fs/f2fs/file.c
> >> > +++ b/fs/f2fs/file.c
> >> > @@ -644,6 +644,23 @@ out:
> >> >  	}
> >> >  }
> >> >
> >> > +#ifdef CONFIG_COMPAT
> >> > +long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigne=
d
> >> > long
> >> > arg)
> >> > +{
> >> > +	switch (cmd) {
> >> > +	case F2FS_IOC32_GETFLAGS:
> >> > +		cmd =3D F2FS_IOC_GETFLAGS;
> >> > +		break;
> >> > +	case F2FS_IOC32_SETFLAGS:
> >> > +		cmd =3D F2FS_IOC_SETFLAGS;
> >> > +		break;
> >> > +	default:
> >> > +		return -ENOIOCTLCMD;
> >> > +	}
> >> > +	return f2fs_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
> >> > +}
> >> > +#endif
> >> > +
> >> >  const struct file_operations f2fs_file_operations =3D {
> >> >  	.llseek		=3D generic_file_llseek,
> >> >  	.read		=3D do_sync_read,
> >> > @@ -655,6 +672,9 @@ const struct file_operations f2fs_file_operation=
s =3D
> >> > {
> >> >  	.fsync		=3D f2fs_sync_file,
> >> >  	.fallocate	=3D f2fs_fallocate,
> >> >  	.unlocked_ioctl	=3D f2fs_ioctl,
> >> > +#ifdef CONFIG_COMPAT
> >> > +	.compat_ioctl	=3D f2fs_compat_ioctl,
> >> > +#endif
> >> >  	.splice_read	=3D generic_file_splice_read,
> >> >  	.splice_write	=3D generic_file_splice_write,
> >> >  };
> >> > --
> >> > 1.7.9.5
> >> >
> >> >
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-fsdeve=
l"
> >> in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > --
> > Jaegeuk Kim
> > Samsung
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Jaegeuk Kim
Samsung

--=-qISzmLpL4A7FDB+xA2sf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJRELD4AAoJEEAUqH6CSFDSEDYP/2ea0cs+CkgJkPMrXPWBY9qH
z88hg/HOKaTEOWdYfZ9ep73g5ocRrtibvzemmENzgk6XpP54pV51QBNLfI1ttbgk
XYbR+Lf4vwuAT3dgzcAo4yLwQtuTIXQOBVVM9rR1m8VmSFvrPgtWvQasYwAMt5aE
K/x2WhQHuJLmTh7Zueqm9NxZd4Xy6ga2yRbhHCkWMsaFk0z/xmJPnK0ZD2JWtmJe
bpRcO+Mv5pYxr6xCYY+vkPAqvwgbs6XtFpfHq0SDL0xV/cy2Pj9qddLK10yYnCOr
q0leYp922P7cxpwiX8HWnRslLtOU0lzYOILLYAKJ7JX7sk5ToJ266bx24Uf9V/vW
95RWctBfgElGXpshh0/KaSqG3JcFDdkZGpzBpW8c2fcuQpcsPhaKuyhsCPM7bSeh
HHboAODs1SKocV6SQQz/9RNwRvXUYCF52SGYJKZNskQgm0tWhky0BZsCXWKx1xvq
kJYqTynltH6lLUSMFGr+RB+3URSnbjSkXowQ6GIHrPZlOCUPLmF8eocbPGdSRhtJ
a8prDnQgw2HleLeFLahcCmPPnRN1I+ASXxJ6UQIkvjfx5D+e1vSGUxnlSQWucyLr
deWOFk2fDLK8arXdd/vErr7+xK/IAXmv/CTbRoctJGdhyIaEFUarwhYT8dk5aorT
I36+0+6cQrIGsOVQyKGT
=8d7S
-----END PGP SIGNATURE-----

--=-qISzmLpL4A7FDB+xA2sf--


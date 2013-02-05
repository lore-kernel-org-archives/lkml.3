Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab3BEGpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 01:45:49 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:57055 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab3BEGpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 01:45:47 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-80-5110aa990cfe
Message-id: <1360046719.26950.26.camel@kjgkr>
Subject: Re: [PATCH] f2fs: add compat_ioctl to provide backward compatability
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Tue, 05 Feb 2013 15:45:19 +0900
In-reply-to: <CAKYAXd8QsGzz0FHUNZfBt7kskPQprVrTQcuag75oxx09_R22Ow@mail.gmail.com>
References: <1359988901-7384-1-git-send-email-linkinjeon@gmail.com>
 <CAKYAXd8QsGzz0FHUNZfBt7kskPQprVrTQcuag75oxx09_R22Ow@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-udKgq0q+nI66hfypoIGf"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t8zY91ZqwQCDT4vY7LYs/cki8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mo4N9+uoFml4uC6x4wNjOtkuxg5OSQETCQmrX3MBGGL
	SVy4t56ti5GLQ0hgGaPEj61bWGGKrjw4A5VYxCjR+24nC4TzmlHi66fPYO28AroSZydOYAOx
	hQV8Jb6u7GHsYuTgYBPQlti83wAkLCSgKPF2/11WkLCIgJrEhGepIGOYBXYxShw7uoQFpIZF
	QFVi26YudhCbUyBY4u+bJiaIXV2MEqtbNjCCJPgFRCVOtn4Cs5kFqiQ+H1zKAnGpksTu9k52
	iHsEJX5Mvgd2qITAI3aJj11T2SA2CEh8m3yIBeQKCQFZiU0HmCF6JSUOrrjBMoFRfBaSsbOQ
	jIKIa0q0bv/NDmFrSyxb+JoZwraVWLfuPVSNjcSmqwsYIWx5ie1v5zAvYGRfxSiaWpBcUJyU
	nmukV5yYW1yal66XnJ+7iRESldI7GFc1WBxiFOBgVOLh/XGZP1CINbGsuDL3EKMK0JxHG1Zf
	YJRiycvPS1US4f14AyjNm5JYWZValB9fVJqTWnyIsQrouYnMUqLJ+cBEklcSb2hsbGJmYmpi
	bmlqbkoVYSVxXsZTTwKEBNITS1KzU1MLUotgljNxcEo1MDrriO0OuLXJLDzVMnN9WISJD/9M
	8UnJpnd5zVcxOOayrxDk2mLc9bYh4Mn6sPOrdyeKRt77Gfzx15bjq65PP77h/O37a3wvLD4f
	5pxtyhC//HmqwPS1jneN9kwWXXNl69Xvb+0vmER9PjhFkE9W++DfrRu8Q4OnHw/wkX1wYXb2
	ZoUIH7H5PKpKLMUZiYZazEXFiQCvWBQVMQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsVy+t9jAd2ZqwQCDS5es7TYs/cki8XlXXPY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMODffrqBZpeLg
	useMDYzrZLsYOTkkBEwkrjw4wwZhi0lcuLceyObiEBJYxCjR+24nC4TzmlHi66fPTCBVvAK6
	EmcnTgDrEBbwlfi6soexi5GDg01AW2LzfgOQsJCAosTb/XdZQcIiAmoSE56lgoxhFtjFKHHs
	6BIWkBoWAVWJbZu62EFsToFgib9vmpggdnUxSqxu2cAIkuAXEJU42foJzGYWqJL4fHApC8Sl
	ShK72zvZIe4RlPgx+R7LBEbBWUjKZiFJQcQ1JVq3/2aHsLUlli18zQxh20qsW/ceqsZGYtPV
	BYwQtrzE9rdzmBcwsq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI75Z9I7GFc1WBxiFOBg
	VOLh/XGZP1CINbGsuDL3EKMK0JxHG1ZfYJRiycvPS1US4f14AyjNm5JYWZValB9fVJqTWnyI
	cSIjMDwmMkuJJucDE1VeSbyhsYmZkaWRmYWRibk5LYWVxHkZTz0JEBJITyxJzU5NLUgtgjmK
	iYNTqoExqWzVMo7t8+XWzFQVUl5c0cJzqUAvWF9nQv2hN7r5NSwXzeeu3PROWLv9u7vWnru3
	LFJXrV/beca0sfWyRf39/GmrmWsm3D8R5ThDO+HF1cbtqZwbnS5fKSyQ2yj1foN0eBJr3A1O
	9amzJ6R485xrmSPRlaz+c+bOU4xC9skq05ImyzQy/LdVYinOSDTUYi4qTgQAQq/ADngDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-udKgq0q+nI66hfypoIGf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

2013-02-05 (=ED=99=94), 14:28 +0900, Namjae Jeon:
> Hi Jaegeuk.
>=20
> Oops!, I was missing include header.
> Sorry, I will send v2 patch again.

I got a build error, and simply added the following header file in your
patch.

#include <linux/compat.h>

Is it correct?

Thanks,

>=20
> Thanks.
>=20
> 2013/2/4, Namjae Jeon <linkinjeon@gmail.com>:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > adding compat_ioctl to provide support for backward comptability - 32bi=
t
> > binary
> > execution on 64bit kernel.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> > ---
> >  fs/f2fs/f2fs.h |   15 +++++++++++++++
> >  fs/f2fs/file.c |   20 ++++++++++++++++++++
> >  2 files changed, 35 insertions(+)
> >
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index 58dd608..7bf86c8 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -104,6 +104,20 @@ static inline int update_sits_in_cursum(struct
> > f2fs_summary_block *rs, int i)
> >  }
> >
> >  /*
> > + * ioctl commands
> > + */
> > +#define F2FS_IOC_GETFLAGS               FS_IOC_GETFLAGS
> > +#define F2FS_IOC_SETFLAGS               FS_IOC_SETFLAGS
> > +
> > +#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
> > +/*
> > + * ioctl commands in 32 bit emulation
> > + */
> > +#define F2FS_IOC32_GETFLAGS             FS_IOC32_GETFLAGS
> > +#define F2FS_IOC32_SETFLAGS             FS_IOC32_SETFLAGS
> > +#endif
> > +
> > +/*
> >   * For INODE and NODE manager
> >   */
> >  #define XATTR_NODE_OFFSET	(-1)	/*
> > @@ -850,6 +864,7 @@ void f2fs_truncate(struct inode *);
> >  int f2fs_setattr(struct dentry *, struct iattr *);
> >  int truncate_hole(struct inode *, pgoff_t, pgoff_t);
> >  long f2fs_ioctl(struct file *, unsigned int, unsigned long);
> > +long f2fs_compat_ioctl(struct file *, unsigned int, unsigned long);
> >
> >  /*
> >   * inode.c
> > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > index 633667e..e79d26a 100644
> > --- a/fs/f2fs/file.c
> > +++ b/fs/f2fs/file.c
> > @@ -644,6 +644,23 @@ out:
> >  	}
> >  }
> >
> > +#ifdef CONFIG_COMPAT
> > +long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned l=
ong
> > arg)
> > +{
> > +	switch (cmd) {
> > +	case F2FS_IOC32_GETFLAGS:
> > +		cmd =3D F2FS_IOC_GETFLAGS;
> > +		break;
> > +	case F2FS_IOC32_SETFLAGS:
> > +		cmd =3D F2FS_IOC_SETFLAGS;
> > +		break;
> > +	default:
> > +		return -ENOIOCTLCMD;
> > +	}
> > +	return f2fs_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
> > +}
> > +#endif
> > +
> >  const struct file_operations f2fs_file_operations =3D {
> >  	.llseek		=3D generic_file_llseek,
> >  	.read		=3D do_sync_read,
> > @@ -655,6 +672,9 @@ const struct file_operations f2fs_file_operations =
=3D {
> >  	.fsync		=3D f2fs_sync_file,
> >  	.fallocate	=3D f2fs_fallocate,
> >  	.unlocked_ioctl	=3D f2fs_ioctl,
> > +#ifdef CONFIG_COMPAT
> > +	.compat_ioctl	=3D f2fs_compat_ioctl,
> > +#endif
> >  	.splice_read	=3D generic_file_splice_read,
> >  	.splice_write	=3D generic_file_splice_write,
> >  };
> > --
> > 1.7.9.5
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Jaegeuk Kim
Samsung

--=-udKgq0q+nI66hfypoIGf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJREKp/AAoJEEAUqH6CSFDSt60P/j0rDjnjkfH5iol/Huwqn0u0
yrzkiIkH66up+V7e1SSlvD5pUS04f9mrfU8FU5Ovfl7krCRwPQEgVlgLiRJbzgM7
bg8MdFrOern3hW9VuFJOkS7kf0vl5lkQ9FJeHDVHHnVF/OGOKUB3T9R42lFGAdrC
dfN+JrWqq64oPqAiZv+ySAJPw1YTBkRoP+0kHXu8Wo9wgTcP8cU71tqBVMPqL6d+
NoDOXBrn3bnPXTF+ro1Ne5KHYyuQqU3Phi0jJE3INATi/rWC8qcw/HzamaqQ0SeB
TrLS7OkBNSsb7ezAU5ptgTu13Hm7g7Bf0oBrGbWoq9jlfHUQnNYNFsy43YiY7Efk
ZQxkJrGWyxzVQYqOIFroAqRLSSggCGvSmIVMak1oDIFYKAv0VW/ZnXs8n4ch/5RU
XtDLl6M1NN71YJYxQVbHZzV7vjSF7Pk9ewVaAdA+ai5KvF6XkYxAjoJ7HxIyl9SA
m+uqVM6WnivBuqO8ccuvq2nM9VLpLkJ6nB1WWq7F6bluKxDjbo10GCJ5DQP0kH5Q
xLWjNj2iqpIJ8/B/Q0vuSndDRpy0Nfn535LndEmqOf/eLHnSeD8Fff6u+jlcPh5R
dQcLbj/+pMw6q5+fHL9nlZzHi/D+0dK0iiWVw4RDfpfuK6cds0hQyTuBJi9mQc34
pfF56GcRv4U+owBS7SCe
=dUFj
-----END PGP SIGNATURE-----

--=-udKgq0q+nI66hfypoIGf--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3BFJWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:22:20 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:8614 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3BFJWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:22:15 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-5e-511220c63c9a
Message-id: <1360142506.26950.56.camel@kjgkr>
Subject: Re: [PATCH] f2fs: fix to name f2fs GC task as per partition instead of
 per device
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Wed, 06 Feb 2013 18:21:46 +0900
In-reply-to: <CAKYAXd_45Y5H30wGVHZGNn8f=xNpiXBEq2UxfdRWznHrxw7drQ@mail.gmail.com>
References: <1360074293-8252-1-git-send-email-linkinjeon@gmail.com>
 <1360125680.26950.55.camel@kjgkr>
 <CAKYAXd_45Y5H30wGVHZGNn8f=xNpiXBEq2UxfdRWznHrxw7drQ@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-tBgxyatIYjWEYNsvbtS0"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t8zI91jCkKBBm9vcFjs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW873/CXHBCo+LS7GNMDYzvFLoYOTkkBEwkpr/aywJh
	i0lcuLeerYuRi0NIYBmjxK4pmxhhivbN28oMYgsJTGeUuPmKFcJ+zShx8EUwiM0roCvx5sAc
	JhBbWCBG4t/F50A2BwebgLbE5v0GEOWKEm/332UFCYsIqElMeJYKsopZYBejxLGjS8BuYBFQ
	lbhyuxlsPKdAsETvrv+MEPesY5S4f/UjWIJfQFTiZOsnsNuYBaokpu0+zARxp5LE7vZOdoh7
	BCV+TL7HAtIsIXCPXWLuq9OsEBsEJL5NPsQCcoWEgKzEpgPMEL2SEgdX3GCZwCg+C8nYWUhG
	QcQ1JVq3/2aHsLUlli18zQxh20qsW/ceqsZGYtPVBYwQtrzE9rdzmBcwsq9iFE0tSC4oTkrP
	NdIrTswtLs1L10vOz93ECIlJ6R2MqxosDjEKcDAq8fDe0BMMFGJNLCuuzD3EqAI059GG1RcY
	pVjy8vNSlUR4TaWFAoV4UxIrq1KL8uOLSnNSiw8xVgE9N5FZSjQ5H5hG8kriDY2NTcxMTE3M
	LU3NTakirCTOy3jqSYCQQHpiSWp2ampBahHMciYOTqkGxmk+7xfM2LV+2Zd3866xa0hasFbM
	Ocbpxc6tPPuYHL9n3cSSANndz7/Nt7It5sq5KC84cbcSkxZrTeuaBXZXHyUwNPcx17I8XezY
	FZ+yvCS+L+Pq2ckLzl6fHrszu1p7/kmJxO3Fp4S2zImbaRKRYXaouGndrF1L1wjU/HBr43j2
	aV9th4u5hRJLcUaioRZzUXEiAO67QTEwAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jQd1jCkKBBlv0LfbsPclicXnXHDYH
	Jo/Pm+QCGKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ0
	3TJzgCYrKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDPe9z9hLjihUXFp
	9jGmBsZ3Cl2MnBwSAiYS++ZtZYawxSQu3FvPBmILCUxnlLj5ihXCfs0ocfBFMIjNK6Ar8ebA
	HCYQW1ggRuLfxedANgcHm4C2xOb9BhDlihJv999lBQmLCKhJTHiW2sXIxcEssItR4tjRJSwg
	NSwCqhJXbjeDjecUCJbo3fWfEaRISGAdo8T9qx/BEvwCohInWz8xgtjMAlUS03YfZoK4U0li
	d3snO8Q9ghI/Jt9jmcAoOAtJ2SwkKYi4pkTr9t/sELa2xLKFr5khbFuJdeveQ9XYSGy6uoAR
	wpaX2P52DvMCRvZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHx/kx6B+OqBotDjAIcjEo8
	vDf0BAOFWBPLiitzDzGqAM15tGH1BUYplrz8vFQlEV5TaaFAId6UxMqq1KL8+KLSnNTiQ4wT
	GYHhMZFZSjQ5H5ik8kriDY1NzIwsjcwsjEzMzWkprCTOy3jqSYCQQHpiSWp2ampBahHMUUwc
	nFINjF6HVOcqPHkbZarM5WZ3VXrv8Uo5A3m1Rjb36e92b6qfIDpb/j2v9++VAmF5d5kOf+/m
	OCNR8fy9GPeytJwjx462S6zNndE14+1K18JOzoJTbp0v5uYoMiX+PzX9gudyF8HFGzQ9d//J
	39MV3ZKTu1St0DApxOr0c/tNrwLnss2U9gyP59nkqsRSnJFoqMVcVJwIAFGlz5N2AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tBgxyatIYjWEYNsvbtS0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

2013-02-06 (=EC=88=98), 13:59 +0900, Namjae Jeon:
> 2013/2/6, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > Hi,
> >
> > How about this?
> >
> > 2013-02-05 (=ED=99=94), 23:24 +0900, Namjae Jeon:
> >> From: Namjae Jeon <namjae.jeon@samsung.com>
> >>
> >> After the commit 2184ad190a79ae2b40b5f5db1fbde5c22db6d310, it allowed
> >> for naming GC threads based on the device.
> >> i.e., if we have F2FS formatted partition in different devices - we wi=
ll
> >> have their GC thread names after the device. But, when we have a case
> >> like
> >> 2 or more partitions on the same device having F2FS filesystem.
> >> In that case we are not able to differentiate between the GC threads.
> >> So, to differentiate at all possible levels we can use the major/minor=
 of
> >> the device to have unique identification in the name.
> >>
> >> Before patch:
> >> root  9726  0.0  0.0  0  0 ?  S  14:32   0:00 [f2fs_gc-8:48]
> >> root  9736  0.0  0.0  0  0 ?  S  14:32   0:00 [f2fs_gc-8:16]
> >> root  9892  0.0  0.0  0  0 ?  S  14:33   0:00 [f2fs_gc-8:32]
> >> root  9907  0.0  0.0  0  0 ?  S  14:34   0:00 [f2fs_gc-8:32]
> >>
> >> After Patch:
> >> root  16756  0.0  0.0  0  0 ?  S  14:57   0:00 [f2fs_gc-8:18]
> >> root  16765  0.0  0.0  0  0 ?  S  14:57   0:00 [f2fs_gc-8:19]
> >> root  16806  0.0  0.0  0  0 ?  S  14:58   0:00 [f2fs_gc-8:34]
> >> root  16817  0.0  0.0  0  0 ?  S  14:58   0:00 [f2fs_gc-8:52]
> >>
> >
> > root  16756  0.0  0.0  0  0 ?  S  14:57   0:00 [f2fs_gc-sdb1]
> > root  16765  0.0  0.0  0  0 ?  S  14:57   0:00 [f2fs_gc-sdb2]
> >
> > IMO, it would be better to describe like this.
> > We can simply use bdevname(bdev, name), so if no objection, I'll rebase
> > this patch with this.
> > Please, give me your opinion.
> > Thanks,
> Hi Jaegeuk.
>=20
> Although it is good opinion to have user friendly names in the task
> list, but we cannot have such names.
>=20
> Because, even though bdevname() will provide the correct string. But
> there is a limitation from the task struct command length.
> The Task struct allows for the name to be maximum of =E2=80=9816=E2=80=99=
 characters in length.
> char comm[TASK_COMM_LEN];
>=20
> /* Task command name length */
> #define TASK_COMM_LEN 16
> So, the task name would be truncated to =E2=80=9816=E2=80=99 characters.
>=20
> In case like for MMC partitions where partition name can be like:
> mmcblk0p18, the name would become f2fs_gc-mmcblk0p18 -> this will be
> truncate to =E2=80=9Cf2fs_gc-mmcblk0p=E2=80=9D

Agreed.
Thank you for explanation. :)

>=20
> Let me know your opinion.
> Thanks.
> >
> >
> >> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> >> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> >> ---
> >>  fs/f2fs/gc.c |    3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> >> index 742135a..b0c1f8c 100644
> >> --- a/fs/f2fs/gc.c
> >> +++ b/fs/f2fs/gc.c
> >> @@ -91,6 +91,7 @@ static int gc_thread_func(void *data)
> >>  int start_gc_thread(struct f2fs_sb_info *sbi)
> >>  {
> >>  	struct f2fs_gc_kthread *gc_th;
> >> +	dev_t dev =3D sbi->sb->s_bdev->bd_dev;
> >>
> >>  	if (!test_opt(sbi, BG_GC))
> >>  		return 0;
> >> @@ -101,7 +102,7 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
> >>  	sbi->gc_thread =3D gc_th;
> >>  	init_waitqueue_head(&sbi->gc_thread->gc_wait_queue_head);
> >>  	sbi->gc_thread->f2fs_gc_task =3D kthread_run(gc_thread_func, sbi,
> >> -				"f2fs_gc-%s", dev_name(sbi->sb->s_bdi->dev));
> >> +				"f2fs_gc-%u:%u", MAJOR(dev), MINOR(dev));
> >>  	if (IS_ERR(gc_th->f2fs_gc_task)) {
> >>  		kfree(gc_th);
> >>  		sbi->gc_thread =3D NULL;
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

--=-tBgxyatIYjWEYNsvbtS0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJREiCqAAoJEEAUqH6CSFDS1qAP/R5FTzFvY9zNcL/iHDK71seS
P8V2JTfq8lnrj9qxI0Fwyq8bsGX/tnXtRQukwf5NQuYh9IG6gVE/Ik11ytD3A8yi
6ghvSYz2BnVBRkVV1a5sFdivnp4DZsCrxXZj2229UnXtIW+rK+bB7Q/3WFm+E/Rn
FM3elBKdyJllyrpCSeiua2EjhXK6Co+/Ui0GkCX4dpqeUNgMckRf/FcN+gDaRtjG
kCinrKDLphuxwPDMiRvrQRUgeMyASLvVrRZry6Zc6aYlmUPbQBgCBZWZWBTmxn7q
wuou/rItCidBZE+pPGGugjBLTp/ReY4TS8gCVvWn/7qcOXUELeIzkLvm7r22qn54
EmnR4bX1frzE3qaqRMm5ykD8NQstOhrjoQzW8RCC2bC8npoIb0l5EWcQopb9bynA
ECcRO0fRRb8+kyqYk8Ac11s92wguoHlnkMUoTHlD/2E7SrvUG8Rd2lSXcOIpTZZp
VWkksCv38xCAdrGLty1A6jRJUnbFY11Z8ObwKhb1tTjEmsf4Uxtt9ck8UwGAccA1
68i1ikFPULzxihChgaAr/cd4vVPMOhswrw2YXYtXlE0lqGHN3wO9suUcjIjqA0pz
7VqgBO/aS19th0/toMMmS0g1LOrsIDJR1R3ThYY6iBGQ/zvedhF/rlogS0nbJFMt
H+aSEVKOrm0TUEyN0PuN
=yKAz
-----END PGP SIGNATURE-----

--=-tBgxyatIYjWEYNsvbtS0--


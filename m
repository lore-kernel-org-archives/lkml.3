Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3FYGDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 02:03:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12725 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3FYGDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 02:03:45 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-fc-51c932c0ea27
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1372140227.28480.69.camel@kjgkr>
Subject: Re: [PATCH 2/2] f2fs: add sysfs support for controlling the gc_thread
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Date: Tue, 25 Jun 2013 15:03:47 +0900
In-reply-to: <CAKYAXd-OO5niMiFv+ysStw=c-NQXT4AkTz3m7o1wTRZRd=WYFw@mail.gmail.com>
References: <1369533945-6955-1-git-send-email-linkinjeon@gmail.com>
 <1369619214.10521.25.camel@kjgkr>
 <CAKYAXd_QZronHD536LOfeFWLmtCoweRq3gbH94R4_7oKC7hv3w@mail.gmail.com>
 <1369704867.10521.46.camel@kjgkr>
 <CAKYAXd-OO5niMiFv+ysStw=c-NQXT4AkTz3m7o1wTRZRd=WYFw@mail.gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zQ90DRicDDdrPs1lcv3uL2eLSIneL
	PXtPslhc3jWHzeLH9HqLH7vOMzuweeycdZfdY/eCz0wefVtWMXp83iQXwBLFZZOSmpNZllqk
	b5fAlfHr/iTmgv9yFavO/GJqYJwt0cXIwSEhYCLxZqVoFyMnkCkmceHeerYuRi4OIYFljBLv
	Nn5jh6npXhgEEV/EKPHjfwMzSAOvgKDEj8n3WEBsZgF1iUnzFjFD2CIS2y/cZ4KwtSWWLXzN
	DNH8mlHi2KLnLBDNuhJTd30Ds4UF/CQmTvjFDLKMDahh834DkLCQgKLE2/13WUHCIgJqEhOe
	pUKM3MEo0XTQHMRmEVCVWHr+ARuIzSkQLHHpy0d2iFUzmSTO9v4Cu4dfQFTi8MLtzBBPKkns
	bu8EK5IQuMUuMe3xWiaISQIS3yYfYoF4WFZi0wGoekmJgytusExglJyF5OVZSF6eheTlWUhe
	XsDIsopRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjJHZ7dzDePmB9iDEZaP1EZinR5Hxg7OeV
	xBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXFO+f+P
	8+rtSxZPdg86I2nlWC2ty5oSzr3m6rI9wienamz/fPj0t89a165Pd46Re/629PG+1ZvDlER7
	Dwj3/dRMcLwTwPRE5Cj3xZk159InHkwuZpj+c/4zZWXDGRv5OmSEZC6rqC3x6l68+s4fhsJJ
	gV/mX0pfcYRhYsQKPsHdnM5CEu0G5zyUWIozEg21mIuKEwEzVKyW8wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jAd39RicDDXofSVtcv3uL2eLSIneL
	PXtPslhc3jWHzeLH9HqLH7vOMzuweeycdZfdY/eCz0wefVtWMXp83iQXwBLVwGiTkZqYklqk
	kJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RbSaEsMacUKBSQWFys
	pG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5jxZ8VPtoLXchW3l/SxNDC2S3QxcnBICJhIdC8M
	6mLkBDLFJC7cW8/WxcjFISSwiFHix/8GZpAEr4CgxI/J91hA6pkF5CWOXMoGCTMLqEtMmreI
	GaL+NaPEsUXPWSDqdSWm7voGZgsL+ElMnPCLGaSXTUBbYvN+A5CwkICixNv9d1lBwiICahIT
	nqVCjNzBKNF00BzEZhFQlVh6/gEbiM0pECxx6ctHdohVM5kkzvb+AjuNX0BU4vDC7cwQ9ytJ
	7G7vZJ/AKDQLydWzEK6eheTqBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC4/yZ1A7G
	lQ0WhxgFOBiVeHgjd50IFGJNLCuuzD3EKMHBrCTCGyoCFOJNSaysSi3Kjy8qzUktPsSYDHT5
	RGYp0eR8YArKK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbG
	fT9CV/bdSFyaXf57vVQNQ915qe1qBbHFVpr5e6TPqslJ7PE+NvuOz6P3Mj7zitk+2Gw0mH3l
	ZWy/ymx3P5e0jycmxoVeDn1zdfOGl3ZNxcL98vHvm1WYbVnuaDuen5x2g/10ZMZDC85jrp2v
	LuYcZ9Tj5s/Mmc0qtrPq//V/G3g+9/Lu/m+ixFKckWioxVxUnAgALE8inTcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namjae,

Sorry for the late reply.

2013-05-29 (수), 09:01 +0900, Namjae Jeon:
> >> I have thought more after getting your reply.
> >> f2fs_cleaner(a tentative name) is that provide the following several
> >> options to control gc thread.
> >> 1. start forground gc thread to clean all invalid blocks.
> >> 2. stop number 1(fg) working.
> >> 3. set new tunning parameter (min/max/no_gc).
> >> 4. get status of current f2fs.
> >> We will provide user level util in f2fs tools and sysfs at the same time.
> >> It is useful if the console level user/App user can change them easily.

I think we'd better support configurable min/max/no_gc times only.
And I don't think users need to do foreground GCs explicitly, since
foreground GCs should be done only when the file system suffers from the
shortage of free space. The foreground GC is the most costly operation
so that I'd like to avoid triggering it as much as possible even if
users want to do.

Otherwise, if users would like to move data, they can just adjust
background GC times appropriately and then do sync if they really move
data synchronously.

> >>
> >> >
> >> > Afterwards, it is worth to add some information to
> >> > Document/filesystems/f2fs.txt.
> >> Yes, It will be included in next series patches.
> >> How do you think ? If you agree my suggestion, I will start to work
> >> the above jobs.
> Hi. Jaegeuk.
> >
> > As I described, basically I agreed that this kind of interfaces and user
> > apps are definitely beneficial to the f2fs users.
> >
> > But wrt design and implementation of new interfaces, we'd better discuss
> > how to use them in more detail and what information should be needed for
> > user-made cleaner.
> > After then, we'd better start to design the interfaces as well as user
> > scenarios clearly.
> Okay. I agree.
> 
> >
> > IMO, the following issues should be addressed.
> > - how to know system idle time by users?
> e.g. When playing PVR function, In case of DTV, App try to read data
> from filesystem of usb device.
> now that, user app will never access flash rw partition and don't need
> to access there.
> I think that we can cleverly use such time to avoid or make slowly
> come in the possible performance regression later.

Okay.

> 
> > - any priority scheme for cleaning?
> Could you plz tell me a little more detail ?

I meant, as well as the GC times, user also gives a kind of status like:
LONG_IDLE, SHORT_IDLE, something like that.
Therefore, how about using this information to select a victim selection
policy between cost-benefit and greedy algorithms?

> 
> > - what status of current f2fs?
> I think that we can get this information how many victim section and
> segment is possible to reclaim in sysfs.
> It will be easily interpreted by the user and it allows the user the
> freedom to check itself if really running GC is useful
> and user can decide to run cleaner at timing they want.
> 
> > - how about supporting that f2fs controls gc times dynamically instead
> > of the user decision?
> Yes, I thought such idea before. It might be useful if gc thread can
> dynamically control own gc times with different partition size and
> available size.
> But I think there is a limitation that f2fs don't predict when user access f2fs.
> So I think that user level controller surely is needed.
> Ah,, And It will be also useful if f2fs is mounted with background_gc_off.

Okay.
Thanks, :)

> 
> Let me know your opinion~.
> 
> Thanks:)
> >
> > Thanks,
> >
> >>
> >> Let me know your opinion.
> >>
> >> Thanks.
> >> >
> >> > Thanks,
> >> >
> >
> > --
> > Jaegeuk Kim
> > Samsung
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jaegeuk Kim
Samsung


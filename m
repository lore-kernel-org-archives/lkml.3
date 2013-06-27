Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab3F0FYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:24:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22612 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3F0FYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:24:35 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68e-b7f276d000002279-08-51cbcc9161aa
Content-transfer-encoding: 8BIT
Message-id: <1372310676.28480.89.camel@kjgkr>
Subject: Re: [PATCH 2/2] f2fs: add sysfs support for controlling the gc_thread
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Date: Thu, 27 Jun 2013 14:24:36 +0900
In-reply-to: <CAKYAXd-NEKCuEyoLwWHLrN165yq7EKRRcz9RknfdbR5EOO6cvQ@mail.gmail.com>
References: <1369533945-6955-1-git-send-email-linkinjeon@gmail.com>
 <1369619214.10521.25.camel@kjgkr>
 <CAKYAXd_QZronHD536LOfeFWLmtCoweRq3gbH94R4_7oKC7hv3w@mail.gmail.com>
 <1369704867.10521.46.camel@kjgkr>
 <CAKYAXd-OO5niMiFv+ysStw=c-NQXT4AkTz3m7o1wTRZRd=WYFw@mail.gmail.com>
 <1372140227.28480.69.camel@kjgkr>
 <CAKYAXd-NEKCuEyoLwWHLrN165yq7EKRRcz9RknfdbR5EOO6cvQ@mail.gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zQ91JZ04HGsz+xWhx/e4tZotLi9wt
	9uw9yWJxedccNosf0+stfuw6z+zA5rFz1l12j90LPjN59G1ZxejxeZNcAEsUl01Kak5mWWqR
	vl0CV8bGMx2sBes5Kw7+uM/UwLiDvYuRk0NCwERi4fWNjBC2mMSFe+vZuhi5OIQEljFKbJt/
	mLWLkQOsaNUDH4j4dEaJfTtaWEAaeAUEJX5MvscCUsMsIC9x5FI2SJhZQF1i0rxFzBD1rxkl
	rn/5wApRryuxb+ousGXCAn4SEyf8YgbpZRPQlti83wAkLCSgKPF2/12wtSICahITnqVCjNzB
	KNF00BzEZhFQlfj+Zw/Y+ZwCwRKzzx5gh1jVwizxZkUr2Cp+AVGJwwu3M0P8pSSxu70TrEhC
	4Ba7xOEJ7xkhJglIfJt8iAXiR1mJTQeg6iUlDq64wTKBUWIWki9nIXw5C8mXCxiZVzGKphYk
	FxQnpRcZ6RUn5haX5qXrJefnbmKERGLfDsabB6wPMSYDbZzILCWanA+M5LySeENjMyMLUxNT
	YyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MC6pj5o48VjIeYcPK1pN
	2X0nGW2bUPPFcrud2IvrwpdOmKrY7532wHonc8OTHQ+Tp57x3+tmzFumo7sggyPW7kX/mp9r
	gz5kVF1tvifsVH5h44tNucm7ZzA9fqieL7SFW/VR/Zxbh34yNwa9PZBb9t3sVUJev5VCfp+D
	4XNuuZMyau62P/1f3lJiKc5INNRiLipOBADOo5v02gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jQd2JZ04HGmw9qmlx/e4tZotLi9wt
	9uw9yWJxedccNosf0+stfuw6z+zA5rFz1l12j90LPjN59G1ZxejxeZNcAEtUA6NNRmpiSmqR
	Qmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBuJYWyxJxSoFBAYnGx
	kr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGxjMdrAXrOSsO/rjP1MC4g72LkYNDQsBEYtUD
	ny5GTiBTTOLCvfVsXYxcHEIC0xkl9u1oYQFJ8AoISvyYfI8FpJ5ZQF7iyKVskDCzgLrEpHmL
	mCHqXzNKXP/ygRWiXldi39RdjCC2sICfxMQJv5hBetkEtCU27zcACQsJKEq83X+XFSQsIqAm
	MeFZKsTIHYwSTQfNQWwWAVWJ73/2sIPYnALBErPPHmCHWNXCLPFmRSvYKn4BUYnDC7czQ9yv
	JLG7vZN9AqPQLCRXz0K4ehaSqxcwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7zZ1I7
	GFc2WBxiFOBgVOLh9WA5HSjEmlhWXJl7iFGCg1lJhDc0ByjEm5JYWZValB9fVJqTWnyIMRno
	8onMUqLJ+cAUlFcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFIN
	jKJFmfHxO3IS5GTs0+/P+PhQa//yKvv/+bqOAvVqAV1TTF+fFo7Kiqv5YMyoV3Tmi9ibjYGL
	DggkPjxy5l9MnUUDk2JV5JejUTsfTk6wWf52VdDVPJUjzywmH0tyf3pHMXdbrvnn611HfL/V
	ToicEHwn6sqcvhW/u8WVFyTnCP07H7cuKrXknBJLcUaioRZzUXEiACuQ3NQ3AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-06-26 (수), 14:10 +0900, Namjae Jeon:
> 2013/6/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> >> > - any priority scheme for cleaning?
> >> Could you plz tell me a little more detail ?
> >
> > I meant, as well as the GC times, user also gives a kind of status like:
> > LONG_IDLE, SHORT_IDLE, something like that.
> > Therefore, how about using this information to select a victim selection
> > policy between cost-benefit and greedy algorithms?
> currently we will provide the option of updating the time values from
> the ‘sysfs’ interface, and the GC policy is selected by default from
> GC thread based upon the gc type, BG or FG.
> So, do you mean we should provide an option to select the default GC
> policy for the user using ‘sysfs’ interface? Like, if the user sets
> “LONG_IDLE” – we choose Cost Benefit and in case of SHORT_IDLE
> “Greedy” ? Please elaborate more on this.

Yes, exact.
For example, if an user configures a small period of GC interval but
gives LONG_IDLE, we can choose cost-benefit.
But, if SHORT_IDLE is given with a long GC period, we need to choose
greedy.
How do you think?
Thanks,

-- 
Jaegeuk Kim
Samsung


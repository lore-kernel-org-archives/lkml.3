Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaBRJGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:06:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbaBRJGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:06:08 -0500
Date: Tue, 18 Feb 2014 10:05:49 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lczerner@localhost.localdomain
To: Namjae Jeon <linkinjeon@gmail.com>
cc: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [PATCH RESEND 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE
 for fallocate
In-Reply-To: <CAKYAXd-bD6ZZgpc9E8V1kD9Dj2wrCkbi1i6drNBdUAwsMiv5gg@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
References: <1391319874-3203-1-git-send-email-linkinjeon@gmail.com> <alpine.LFD.2.00.1402111209450.2225@localhost.localdomain> <CAKYAXd-bD6ZZgpc9E8V1kD9Dj2wrCkbi1i6drNBdUAwsMiv5gg@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1913822621-1392714354=:2216"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1913822621-1392714354=:2216
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 12 Feb 2014, Namjae Jeon wrote:

> Date: Wed, 12 Feb 2014 11:28:35 +0900
> From: Namjae Jeon <linkinjeon@gmail.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu,
>     adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
>     linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
>     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
>     Namjae Jeon <namjae.jeon@samsung.com>,
>     Ashish Sangwan <a.sangwan@samsung.com>
> Subject: Re: [PATCH RESEND 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE
>     for fallocate
> 
> 2014-02-11 20:59 GMT+09:00, Lukáš Czerner <lczerner@redhat.com>:
> > On Sun, 2 Feb 2014, Namjae Jeon wrote:
> >
> >> Date: Sun,  2 Feb 2014 14:44:34 +0900
> >> From: Namjae Jeon <linkinjeon@gmail.com>
> >> To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com,
> >> tytso@mit.edu,
> >>     adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com
> >> Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
> >>     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
> >>     Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon
> >> <namjae.jeon@samsung.com>,
> >>     Ashish Sangwan <a.sangwan@samsung.com>
> >> Subject: [PATCH RESEND 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE
> >> for
> >>     fallocate
> >>
> >> From: Namjae Jeon <namjae.jeon@samsung.com>
> >>
> >> Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
> Hi Lukas.
> >
> > Description is missing here, please provide FALLOC_FL_COLLAPSE_RANGE
> > description so people know what it's supposed to be doing.
> >
> > more comments bellow.
> Okay, I will udpate.
> >
> > Thanks!
> > -Lukas

Hi,

you may have noticed my patches for new FALLOC_FL_ZERO_RANGE
fallocate flag. This changes things around the same area as your
patches does so we should probably figure out which are going to
land in first and then rebase the other on top of that.

One concern I have is that I have not seen any tests provided to
verify the feature. But I just may have missed it. Do you have any
xfstests test or at least fsx and fsstress patches to provide
support for testing FALLOC_FL_COLLAPSE_RANGE ? Patches for
util_linux might also be handy.

Thanks!
-Lukas
--8323328-1913822621-1392714354=:2216--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3EBJ4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 05:56:20 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54886 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3EBJ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 05:56:19 -0400
MIME-Version: 1.0
In-Reply-To: <87fvy53eun.fsf@devron.myhome.or.jp>
References: <1367107703-2665-1-git-send-email-linkinjeon@gmail.com>
	<87ppxd4ddm.fsf@devron.myhome.or.jp>
	<CAKYAXd8v-eF0E2FzLfm1KaZaRu-adQcDVQQeWAiH6-8Pr+BxmA@mail.gmail.com>
	<87bo8v42wx.fsf@devron.myhome.or.jp>
	<CAKYAXd_-Z8Avm-FmLF=MVqHSkzfE1_jczBroyFXv5xgQmr5=XA@mail.gmail.com>
	<87vc722cdu.fsf@devron.myhome.or.jp>
	<CAKYAXd8nTUrW04ADyDkhnJWyjUKiniU+r65J5SMhXT-jHTG+UA@mail.gmail.com>
	<87r4hp3kax.fsf@devron.myhome.or.jp>
	<87k3nh3jzi.fsf@devron.myhome.or.jp>
	<CAKYAXd_DRLG3KzjXEQ_8vD5mFWE95gR+jj3-MYhC3QKgQOLTEA@mail.gmail.com>
	<87fvy53eun.fsf@devron.myhome.or.jp>
Date: Thu, 2 May 2013 18:56:18 +0900
Message-ID: <CAKYAXd95yVtbEmwiaDaxgDsJYbqWDV23rY0GuPKLVf0msSGJ2g@mail.gmail.com>
Subject: Re: [PATCH RESEND v5] fat: editions to support fat_fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/2, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>> AFAIK, preallocation != fallocate. ext*'s preallocation was there at
>>>> before fallocation to optimize block allocation for user data blocks.
>> yes, this is correct , preallocation!= fallocate, we just adopted only
>> the "release part" from that approach
>> Sorry, Would you mind to adopt this approach :) ?
>
> I'm ok as start if it works.
>
> But from this discussion, discard at last close(2) doesn't look like
> working for your requirement. Since you want to discard at last close of
> inode, so, rather, I guess you actually want to discard at last
> dereference of inode.
Okay, I see. I will check your review points again.

Thanks OGAWA for review!
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>

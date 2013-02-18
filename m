Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab3BRNzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 08:55:06 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:44436 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab3BRNzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 08:55:03 -0500
MIME-Version: 1.0
In-Reply-To: <87bobh3ml4.fsf@devron.myhome.or.jp>
References: <1360422191-12382-1-git-send-email-linkinjeon@gmail.com>
	<87bobh3ml4.fsf@devron.myhome.or.jp>
Date: Mon, 18 Feb 2013 22:55:01 +0900
Message-ID: <CAKYAXd8A=K1V0tKiqqLyqiXz29BoevinRHa9YwvAzNOfp_iUQQ@mail.gmail.com>
Subject: Re: [PATCH v6 7/7] Documentation: update nfs option in filesystem/vfat.txt
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/18 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> -nfs           -- This option maintains an index (cache) of directory
>> -              inodes by i_logstart which is used by the nfs-related code to
>> -              improve look-ups.
>> +nfs= stale_rw|nostale_ro
>
> Strange space after nfs=.
Okay, I will fix it.
Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

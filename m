Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3LEOGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:06:04 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:56057 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3LEOGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:06:01 -0500
MIME-Version: 1.0
In-Reply-To: <87eh5wep5x.fsf@devron.myhome.or.jp>
References: <1384688265-2866-1-git-send-email-linkinjeon@gmail.com>
	<87eh5wep5x.fsf@devron.myhome.or.jp>
Date: Thu, 5 Dec 2013 23:06:00 +0900
Message-ID: <CAKYAXd-DHy3SPYQrgXrZ9+fxNtn0DQt6XRj8m7sza97HwMeDYQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] fat: add i_disksize to represent uninitialized size
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi OGAWA.
2013/12/1, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>  	/* NOTE: mmu_private is 64bits, so must hold ->i_mutex to access */
>> -	loff_t mmu_private;	/* physically allocated size */
>> +	loff_t mmu_private;	/* physically allocated size (uninitialized) */
>> +	loff_t i_disksize;	/* physically allocated size (initialized) */
>
> comment is correct? (iirc, mmu_private is initialized)
Ah.. I made a mistake. I will fix it.
Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>

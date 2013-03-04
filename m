Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab3CDHX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:23:28 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57695 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab3CDHX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:23:27 -0500
MIME-Version: 1.0
In-Reply-To: <87ehfygi1u.fsf@devron.myhome.or.jp>
References: <1362195832-20942-1-git-send-email-linkinjeon@gmail.com>
	<87ehfygi1u.fsf@devron.myhome.or.jp>
Date: Mon, 4 Mar 2013 16:23:26 +0900
Message-ID: <CAKYAXd9Ji0EF0o8=7JampM28JkcyjqOb_SVM6XB8fv=TrC8-GQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/7] fat (exportfs): support stale_rw and nostale_ro
 mount option.
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/2, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> This patch set eliminates the client side ESTALE errors when a FAT
>> partition
>> exported over NFS has it's dentries evicted from the cache. The idea is
>> to
>> find the on-disk location_'i_pos' of the dirent of the inode that has
>> been
>> evicted and use it to rebuild the inode.
>
> Looks like users can start to test this.
>
> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
> Thanks.
Okay, Thanks OGAWA.
I will start to work write support on fat exportfs.

> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>

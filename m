Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3CBLZY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 06:25:24 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:42483 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3CBLZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 06:25:23 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH v7 0/7] fat (exportfs): support stale_rw and nostale_ro mount option.
References: <1362195832-20942-1-git-send-email-linkinjeon@gmail.com>
Date: Sat, 02 Mar 2013 20:25:17 +0900
In-Reply-To: <1362195832-20942-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sat, 2 Mar 2013 12:43:52 +0900")
Message-ID: <87ehfygi1u.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> This patch set eliminates the client side ESTALE errors when a FAT partition
> exported over NFS has it's dentries evicted from the cache. The idea is to
> find the on-disk location_'i_pos' of the dirent of the inode that has been
> evicted and use it to rebuild the inode.

Looks like users can start to test this.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

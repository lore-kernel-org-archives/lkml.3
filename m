Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab3LFOj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:39:27 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:65102 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442Ab3LFOjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:39:25 -0500
MIME-Version: 1.0
In-Reply-To: <8738m7fge5.fsf@devron.myhome.or.jp>
References: <1384688316-3003-1-git-send-email-linkinjeon@gmail.com>
	<87wqjod97k.fsf@devron.myhome.or.jp>
	<CAKYAXd8NS56AYO-EGs4SM9jVn7AfsQbKznxXP2t7Xf2qDXUo1g@mail.gmail.com>
	<8738m7fge5.fsf@devron.myhome.or.jp>
Date: Fri, 6 Dec 2013 23:39:24 +0900
Message-ID: <CAKYAXd-Xx+bBWRiEmYk6kf+2xjRkFcfQTGnrt0=7sNDEKzWX-g@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] fat: permit to return phy block number by fibmap
 in fallocated region
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/6, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>> ->i_mutex doesn't work for swapfile.
>> Sorry, Actually, I don't understand why it is related with swapfile.
>> Could you elaborate more ?
>
> swapfile.c calls ->bmap to know physical address in swapfile. However,
> swapfile.c calls ->bmap under inode->i_mutex.
Okay, Thanks for explanation.

>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab3BROFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 09:05:37 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:40651 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab3BROFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 09:05:36 -0500
MIME-Version: 1.0
In-Reply-To: <877gm526hr.fsf@devron.myhome.or.jp>
References: <1360422145-12280-1-git-send-email-linkinjeon@gmail.com>
	<87fw0t3mq0.fsf@devron.myhome.or.jp>
	<877gm526hr.fsf@devron.myhome.or.jp>
Date: Mon, 18 Feb 2013 23:05:35 +0900
Message-ID: <CAKYAXd8JX=8s7LzCS1oKvd__0S9ak_fYek=0=BJp-wEUpEKH5g@mail.gmail.com>
Subject: Re: [PATCH v6 4/7] fat: restructure export_operations
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
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>
>>> +    if (parent && (len < FAT_FID_SIZE_WITH_PARENT)) {
>>> +            *lenp = FAT_FID_SIZE_WITH_PARENT;
>>> +            return 255;
>>> +    } else if (len < FAT_FID_SIZE_WITHOUT_PARENT) {
>>> +            *lenp = FAT_FID_SIZE_WITHOUT_PARENT;
>>> +            return 255;
>
> We would be better to use FILEID_INVALID on all places, instead of 255.
Yes, right. I will fix it.
Thanks!
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

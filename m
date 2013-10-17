Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3JQKHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:07:49 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:37648 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3JQKHr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:07:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAGG-pUSWwHDx4TjRwYC8i1a3=uAFueKDXUycGMgy5j1kr65KDg@mail.gmail.com>
References: <1381939056-27898-1-git-send-email-geyslan@gmail.com>
	<20131016193958.GA3961@kroah.com>
	<CAGG-pUSWwHDx4TjRwYC8i1a3=uAFueKDXUycGMgy5j1kr65KDg@mail.gmail.com>
Date: Thu, 17 Oct 2013 07:07:46 -0300
Message-ID: <CAGG-pUSyWStNAFUbBkHtuSTjEFjtZwad2ugsFuYLepi4mWC2Yw@mail.gmail.com>
Subject: Re: [PATCH] drivers: staging: dgnc: Remove useless casting in dgnc_driver.c
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-br <kernel-br@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/16 Geyslan Gregório Bem <geyslan@gmail.com>:
> 2013/10/16 Greg KH <gregkh@linuxfoundation.org>:
>> On Wed, Oct 16, 2013 at 12:57:35PM -0300, Geyslan G. Bem wrote:
>>> Casting (void *) value returned by kzalloc is useless
>>> as mentioned in Documentation/CodingStyle, Chap 14.
>>>
>>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>>> ---
>>>  drivers/staging/dgnc/dgnc_driver.c | 6 ++----
>>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> This patch doesn't apply at all, what tree did you make it against?
>>
>> Please redo it (and your second one) against either the linux-next
>> releases, or my staging-next branch of my staging.git tree on
>> git.kernel.org.
>>
>> thanks,
>>
>> greg k-h
>
> Hi Greg,
>
> I was using the torvalds tree. I noted that yours is different from his.
> So, downloading and soon sending the second patch against your staging
> (https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/).
>
> Thanks.
>
> Geyslan.

Already done. Patch is unneeded.

Regards.

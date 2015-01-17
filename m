Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbbAQT5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 14:57:11 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:58204 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbbAQT5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 14:57:09 -0500
Message-ID: <54BABE91.8020609@gmail.com>
Date: Sat, 17 Jan 2015 22:57:05 +0300
From: Dmitry Tunin <hanipouspilot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] ath3k: Add support of AR3012 bluetooth 13d3:3423 device
References: <54B98679.5060104@gmail.com> <2E4EB7E1-D16C-4633-8E86-337D42190298@holtmann.org> <54BA1CC9.8060601@gmail.com> <F80A6947-61FA-46A1-8742-51129F4E18C3@holtmann.org>
In-Reply-To: <F80A6947-61FA-46A1-8742-51129F4E18C3@holtmann.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any ideas what may be wrong? Is the tree URL correct or there is another bluetooth-next branch I dot know about?
I just clean cloned it again and applied with no problem.

17.01.2015 21:59, Marcel Holtmann пишет:
> Hi Dmitry,
>
> please do not top post on this mailing list.
>
>> This patch is against git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git
>> Or is it another branch?
>>
>> I pulled it again, but still no changes. Why it can be?
>
> it neither applies with git am, nor manually running patch.
>
> checking file drivers/bluetooth/ath3k.c
> Hunk #1 FAILED at 108.
> Hunk #2 FAILED at 162.
> 2 out of 2 hunks FAILED
> checking file drivers/bluetooth/btusb.c
> Hunk #1 FAILED at 189.
> 1 out of 1 hunk FAILED
>
> Regards
>
> Marcel
>

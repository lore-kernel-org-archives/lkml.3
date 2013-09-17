Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3IQSTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 14:19:13 -0400
Received: from mailout.micron.com ([137.201.242.129]:45357 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3IQSTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 14:19:12 -0400
Message-ID: <52389D12.4090109@micron.com>
Date: Tue, 17 Sep 2013 11:18:58 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: David Milburn <dmilburn@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtip32xx: dynamically allocate buffer in debugfs functions
References: <1369344225-4110-1-git-send-email-dmilburn@redhat.com> <51E08A3C.5030001@micron.com>
In-Reply-To: <51E08A3C.5030001@micron.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20154.005
X-TM-AS-Result: No--11.260400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 3:59 PM, Asai Thambi S P wrote:
> On 5/23/2013 2:23 PM, David Milburn wrote:
>
>> Dynamically allocate buf to prevent warnings:
>>
>> drivers/block/mtip32xx/mtip32xx.c: In function ‘mtip_hw_read_device_status’:
>> drivers/block/mtip32xx/mtip32xx.c:2823: warning: the frame size of 1056 bytes is larger than 1024 bytes
>> drivers/block/mtip32xx/mtip32xx.c: In function ‘mtip_hw_read_registers’:
>> drivers/block/mtip32xx/mtip32xx.c:2894: warning: the frame size of 1056 bytes is larger than 1024 bytes
>> drivers/block/mtip32xx/mtip32xx.c: In function ‘mtip_hw_read_flags’:
>> drivers/block/mtip32xx/mtip32xx.c:2917: warning: the frame size of 1056 bytes is larger than 1024 bytes
>>
>> Signed-off-by: David Milburn <dmilburn@redhat.com>
>
> Acked-by: Asai Thambi S P <asamymuthupa@micron.com>
>
Jens,

Please include this patch too for 3.12.

--
Regards,
Asai

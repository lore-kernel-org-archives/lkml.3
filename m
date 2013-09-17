Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3IQSWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 14:22:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53824 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3IQSWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 14:22:09 -0400
Message-ID: <52389DBE.8050901@kernel.dk>
Date: Tue, 17 Sep 2013 12:21:50 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Asai Thambi S P <asamymuthupa@micron.com>
CC: David Milburn <dmilburn@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtip32xx: dynamically allocate buffer in debugfs functions
References: <1369344225-4110-1-git-send-email-dmilburn@redhat.com> <51E08A3C.5030001@micron.com> <52389D12.4090109@micron.com>
In-Reply-To: <52389D12.4090109@micron.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 12:18 PM, Asai Thambi S P wrote:
> On 07/12/2013 3:59 PM, Asai Thambi S P wrote:
>> On 5/23/2013 2:23 PM, David Milburn wrote:
>>
>>> Dynamically allocate buf to prevent warnings:
>>>
>>> drivers/block/mtip32xx/mtip32xx.c: In function
>>> ‘mtip_hw_read_device_status’:
>>> drivers/block/mtip32xx/mtip32xx.c:2823: warning: the frame size of
>>> 1056 bytes is larger than 1024 bytes
>>> drivers/block/mtip32xx/mtip32xx.c: In function ‘mtip_hw_read_registers’:
>>> drivers/block/mtip32xx/mtip32xx.c:2894: warning: the frame size of
>>> 1056 bytes is larger than 1024 bytes
>>> drivers/block/mtip32xx/mtip32xx.c: In function ‘mtip_hw_read_flags’:
>>> drivers/block/mtip32xx/mtip32xx.c:2917: warning: the frame size of
>>> 1056 bytes is larger than 1024 bytes
>>>
>>> Signed-off-by: David Milburn <dmilburn@redhat.com>
>>
>> Acked-by: Asai Thambi S P <asamymuthupa@micron.com>
>>
> Jens,
> 
> Please include this patch too for 3.12.

Queued up.

-- 
Jens Axboe


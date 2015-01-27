Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbbA0XkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:40:00 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47355 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbbA0Xj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:39:59 -0500
Message-ID: <54C8214D.1010404@vanguardiasur.com.ar>
Date: Tue, 27 Jan 2015 20:37:49 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Organization: VanguardiaSur
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, axboe@fb.com, tom.leiming@gmail.com
Subject: Re: [PATCH 2/2 v2] UBI: Block: Add blk-mq support
References: <1420926734-16417-1-git-send-email-richard@nod.at> <1420926734-16417-2-git-send-email-richard@nod.at>
In-Reply-To: <1420926734-16417-2-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2015 06:52 PM, Richard Weinberger wrote:
> Convert the driver to blk-mq.
> Beside of moving to the modern block interface this change boosts
> also the performance of the driver.
> 
> nand: device found, Manufacturer ID: 0x2c, Chip ID: 0xda
> nand: Micron NAND 256MiB 3,3V 8-bit
> nand: 256MiB, SLC, page size: 2048, OOB size: 64
> 
> root@debian-armhf:~# dd if=/dev/ubiblock0_0 of=/dev/zero bs=1M
> 243+1 records in
> 243+1 records out
> 255080448 bytes (255 MB) copied, 4.39295 s, 58.1 MB/s
> 
> vs.
> 
> root@debian-armhf:~# dd if=/dev/ubiblock0_0 of=/dev/zero bs=1M
> 243+1 records in
> 243+1 records out
> 255080448 bytes (255 MB) copied, 2.87676 s, 88.7 MB/s
> 
> Cc: hch@infradead.org
> Cc: axboe@fb.com
> Cc: tom.leiming@gmail.com
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Tested-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>

Acked-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>

And thanks a lot for the good work!

-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar

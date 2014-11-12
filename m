Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaKLAQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 19:16:13 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54369 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaKLAQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 19:16:11 -0500
Date: Wed, 12 Nov 2014 08:16:04 +0800
Subject: Re: [PATCH] arch: tile: gxio: Export symbols for module using in
 'mpipe.c'
Message-ID: <cr8vqhwy7vrnhtnbt7587wmv.1415751123895@email.android.com>
From: Chen Gang <gang.chen.5i5j@gmail.com>
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: "cmetcalf@tilera.com	" <cmetcalf@tilera.com>, rdunlap@infradead.org,
        " " <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAC0GIBc008684

Thank you for your work.

And also please help check the other patch for gdb about tile,
when you have time.

And I also want to consult, can tile be run under qemu or other
simulators? Welcome any ideas, suggestions, and completions.

Thanks.

Send from Lenovo A788t.

Chris Metcalf <cmetcalf@ezchip.com> wrote:

>On 11/9/2014 5:32 AM, Chen Gang wrote:
>> 'gxio_mpipe_adjust_timestamp', 'gxio_mpipe_link_instance',
>> 'gxio_mpipe_get_timestamp', and 'gxio_mpipe_set_timestamp' may be use by
>> other tile modules, so export them.
>>
>> The related error (with allmodconfig under tile):
>>
>>      MODPOST 4002 modules
>>    ERROR: "gxio_mpipe_link_instance" [drivers/net/ethernet/tile/tile_net.ko] undefined!
>>    ERROR: "gxio_mpipe_get_timestamp" [drivers/net/ethernet/tile/tile_net.ko] undefined!
>>    ERROR: "gxio_mpipe_set_timestamp" [drivers/net/ethernet/tile/tile_net.ko] undefined!
>>    ERROR: "gxio_mpipe_adjust_timestamp" [drivers/net/ethernet/tile/tile_net.ko] undefined!
>>
>> Signed-off-by: Chen Gang<gang.chen.5i5j@gmail.com>
>> ---
>>   arch/tile/gxio/mpipe.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>
>Thanks!  Taken into the tile tree.
>
>-- 
>Chris Metcalf, EZChip Semiconductor
>http://www.ezchip.com
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

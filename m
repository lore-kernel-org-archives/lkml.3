Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbaDFX61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:58:27 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47248 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbaDFX6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:58:23 -0400
Message-ID: <5341EA16.6030705@gmail.com>
Date: Mon, 07 Apr 2014 07:58:14 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] fs/ext4/extents_status.c: fix 64-bit number truncation
 bug
References: <53396AC1.10108@gmail.com> <CAMuHMdVT9O8C0fhMbaqS2nB1jfLAZtanp6YGPU6Q-T5b7=n20Q@mail.gmail.com>
In-Reply-To: <CAMuHMdVT9O8C0fhMbaqS2nB1jfLAZtanp6YGPU6Q-T5b7=n20Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/06/2014 09:39 PM, Geert Uytterhoeven wrote:
> On Mon, Mar 31, 2014 at 3:16 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>> '0x7FDEADBEEF' will be truncated to 32-bit number under unicore32. Need
>> append 'ULL' for it.
>>
>> The related warning (with allmodconfig under unicore32):
>>
>>     CC [M]  fs/ext4/extents_status.o
>>   fs/ext4/extents_status.c: In function ‘__es_remove_extent’:
>>   fs/ext4/extents_status.c:813: warning: integer constant is too large for ‘long’ type
> 
> Thanks! This is failing on all 32-bit architectures.
> 

Yeah.

>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> 
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
[...]

Thank you very much!

I will/should continue, and try to finish unicore32 within this month
(although, excuse me, in this week and next week, I will have no much
free time on open source).


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaDGFAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 01:00:35 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55013 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaDGFAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 01:00:33 -0400
Message-ID: <534230E7.3040800@gmail.com>
Date: Mon, 07 Apr 2014 13:00:23 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] fs/ext4/extents_status.c: fix 64-bit number truncation
 bug
References: <53396AC1.10108@gmail.com> <CAMuHMdVT9O8C0fhMbaqS2nB1jfLAZtanp6YGPU6Q-T5b7=n20Q@mail.gmail.com> <20140407041431.GA8468@thunk.org>
In-Reply-To: <20140407041431.GA8468@thunk.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/07/2014 12:14 PM, Theodore Ts'o wrote:
> On Sun, Apr 06, 2014 at 03:39:09PM +0200, Geert Uytterhoeven wrote:
>> On Mon, Mar 31, 2014 at 3:16 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
>>> '0x7FDEADBEEF' will be truncated to 32-bit number under unicore32. Need
>>> append 'ULL' for it.
>>>
>>> The related warning (with allmodconfig under unicore32):
>>>
>>>     CC [M]  fs/ext4/extents_status.o
>>>   fs/ext4/extents_status.c: In function ‘__es_remove_extent’:
>>>   fs/ext4/extents_status.c:813: warning: integer constant is too large for ‘long’ type
>>
>> Thanks! This is failing on all 32-bit architectures.
> 
> Yes, it's harmless (since we don't actually check the value anywhere;
> this is just so humans could easily spot bugs when debugging), but
> I'll make sure this gets queued for 3.15 fixes in the ext4 tree.
> 
> Thanks!!
> 

OK, thanks. Also thank for the related Application usage information.

Next, in open source, welcome to provide related Application usage
information, when review my patches. It will be useful to evaluate my
contributions (at least, it can let myself more clearer).

It will also be useful to me (in fact, for most of my patches, I am not
familiar with the related Application's usage case).


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed

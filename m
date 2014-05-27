Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaE0Acl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:32:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62621 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbaE0Ach (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:32:37 -0400
Message-ID: <5383DD20.8060901@gmail.com>
Date: Tue, 27 May 2014 08:32:32 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Subject: Re: =?UTF-8?B?5Zue5aSN77yaIFtQQVRDSCAwLzNdIGFyY2g6IHVuaWNvcmUzMjo=?=
 =?UTF-8?B?IGtzeW1zOiBleHBvcnQgc2V2ZXJhbCBpbXBsZW1ldGVkIHN5bWJvbHMgdG8gYXY=?=
 =?UTF-8?B?b2lkIGNvbXBpbGluZyBmYWlsdXJl?=
References: <2100345427.23793.1401149582787.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <2100345427.23793.1401149582787.JavaMail.root@bj-mail03.pku.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/27/2014 08:13 AM, 管雪涛 wrote:
> ----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
>> unicore32 has implemented 'find_first_bit', 'find_first_zero_bit',
>> 'pm_power_off', and '__cpuc_coherent_kern_range', need export them to
>> avoid compiling failure.
>>
>> The related error (with allmodconfig under unicore32):
>>
>>     MODPOST 4039 modules
>>   ERROR: "find_first_bit" [sound/soc/codecs/snd-soc-uda1380.ko] undefined!
>>   ERROR: "find_first_zero_bit" [net/sctp/sctp.ko] undefined!
>>   [...]
>>   ERROR: "__cpuc_coherent_kern_range" [drivers/misc/lkdtm.ko] undefined!
>>   ERROR: "pm_power_off" [drivers/mfd/retu-mfd.ko] undefined!
>>   [...]
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> 
> Thanks, I'm waiting for these patches.
> And then, I can request-pull in this month.
> 

Thank you for your work. Hope we can finish within this month. And next
month, I shall start another architectures.

But I am still very glad to continue to provide contributions for
unicore32, and as far as I know:

 - allmodconfig under unicore32 finds many warnings which I skipped now.
   (just like allmodconfig under another architectures without '-W')

 - open source unicore32 qemu still need guys to continue.

 - open source unicore32 cross-compiler still need guys to continue.

If I have chance for them, I shall try (at present, I have started
providing contribution to qemu, and just starting for toolchain, and
will start for kvm/xen in 3rd or 4th quater 2014).


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed

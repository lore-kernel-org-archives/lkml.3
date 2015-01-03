Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbbACKJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 05:09:45 -0500
Received: from [42.120.134.249] ([42.120.134.249]:14080 "EHLO
	out1134-249.mail.aliyun.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751034AbbACKJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 05:09:43 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1043731|-1;FP=0|0|0|0|0|-1|-1|-1;HT=r41g03024;MF=gang.chen@sunrus.com.cn;PH=DS;RN=6;RT=6;SR=0;
Message-ID: <54A7C157.40404@sunrus.com.cn>
Date: Sat, 03 Jan 2015 18:15:51 +0800
From: Chen Gang S <gang.chen@sunrus.com.cn>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sound: soc: soc-pcm: Remove useless varialbe 'i'
References: <54A7BA55.3020607@sunrus.com.cn> <s5htx08dw1q.wl-tiwai@suse.de>
In-Reply-To: <s5htx08dw1q.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/3/15 17:59, Takashi Iwai wrote:
> At Sat, 03 Jan 2015 17:45:57 +0800,
> Chen Gang wrote:
>>
>> 'i' is useless in soc_pcm_set_msb(), so remove it, the related warning
>> (with allmodconfig under s390):
>>
>>     CC [M]  sound/soc/soc-pcm.o
>>   sound/soc/soc-pcm.c: In function 'soc_pcm_set_msb':
>>   sound/soc/soc-pcm.c:307:11: warning: unused variable 'i' [-Wunused-variable]
>>     int ret, i;
>>              ^
> 
> Thanks, but this was already fixed.
> 

OK, thanks.

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed

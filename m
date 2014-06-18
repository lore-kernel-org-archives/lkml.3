Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaFRQZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:25:09 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:50563 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaFRQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:25:07 -0400
MIME-Version: 1.0
In-Reply-To: <53A1A354.7030107@suse.cz>
References: <CAF1_xX2oeG0YCLaLZR9ZUY2qiD0-sVB6L10dZppnae7iZV_U3g@mail.gmail.com>
	<53A1A354.7030107@suse.cz>
Date: Wed, 18 Jun 2014 18:25:05 +0200
Message-ID: <CAF1_xX38AWEK5sW8v_RrL=HzAg7JRNyCzgKNuZFzCGV4y2O7Og@mail.gmail.com>
Subject: Re: Regression: firmware: Simplify directory creation + b43 = fails
 to build
From: Ronald <ronald645@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From my .config

 ==> cat /usr/src/config | grep -i b43
CONFIG_EXTRA_FIRMWARE="b43/ucode5.fw b43/b0g0initvals5.fw
b43/b0g0bsinitvals5.fw b43/pcm5.fw"
... snip ...

2014-06-18 16:33 GMT+02:00 Michal Marek <mmarek@suse.cz>:
> Dne 18.6.2014 10:46, Ronald napsal(a):
>> Dear kernel developers,
>>
>> Latest git HEAD (from Torvalds):
>>
>>   CC      drivers/base/firmware_class.o
>>   LD      drivers/base/built-in.o
>>   MK_FW   firmware/b43/ucode5.fw.gen.S
>> /bin/sh: firmware/b43/ucode5.fw.gen.S: Bestand of map bestaat niet
>> (file or directory does not exist, it should not have the .gen.S
>> suffix)
>> /bin/sh: firmware/b43/ucode5.fw.gen.S: Bestand of map bestaat niet
>> ... snip ...
>> /bin/sh: firmware/b43/ucode5.fw.gen.S: Bestand of map bestaat niet
>> firmware/Makefile:185: recept voor doel 'firmware/b43/ucode5.fw.gen.S'
>> is mislukt
>> make[1]: *** [firmware/b43/ucode5.fw.gen.S] Fout 1
>> Makefile:893: recept voor doel 'firmware' is mislukt
>> make: *** [firmware] Fout 2
>> make: *** Wachten op onvoltooide taken...
>
> Where does firmware/b43 come from?
>
> Thanks,
> Michal
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaIHNgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:36:13 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:45760 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbaIHNgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:36:10 -0400
Message-ID: <540DB0BE.2050505@roeck-us.net>
Date: Mon, 08 Sep 2014 06:35:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Xuetao Guan <gxt@pku.edu.cn>
CC: linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: =?UTF-8?B?5Zue5aSN77yaIFJlOiDlm57lpI3vvJogUmU6IOWbnuWkje+8miA=?=
 =?UTF-8?B?UmU6IOWbnuWkje+8miBSZTog5Zue5aSN77yaIFN0YXR1cyBvZiAndW5pY29yZTM=?=
 =?UTF-8?B?MicgYXJjaGl0ZWN0dXJlIGluIExpbnV4IGtlcm5lbA==?=
References: <174974381.13596.1410181022043.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <174974381.13596.1410181022043.JavaMail.root@bj-mail03.pku.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.540DB0CA.0009,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 11
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2014 05:57 AM, Xuetao Guan  wrote:
>
> ----- Guenter Roeck <linux@roeck-us.net> 写道：
>> On 09/04/2014 11:13 PM, Xuetao Guan  wrote:
>> Hi,
>>
>> I made everything I have available at http://server.roeck-us.net/qemu/unicore32/.
>> I tried multiple variants for creating the root file system, including the one
>> on https://github.com/gxt/UniCore32.git and the one using mkrootfs.sh in
>> the link above. No difference - I always see the same crash. Note that the
>> 'init' program is loading, but crashes with above error (0x0000000b is SIGSEGV
>> unless I am missing something).
>>
>> Note that I used the latest qemu for unicore from upstream sources; I was unable
>> to compile it from git@github.com:gxt/QEMU.git. Qemu configuration did not seem
>> to make a difference. The toolchain was extracted from uc4-1.0.5-hard.tgz.
>>
>> Hope this helps,
>> Guenter
>>
> I guess you used the newest kernel to run busybox.
> However, as for unicore32, the newest kernel uses different ABI with uc4-1.0.5 toolchain.
> I'm sorry to make it so confusing.
> I'll update and submit another-ABI patches asap.
>

Whatever is more recent. Guess you'll have to either update the toolchain
or the kernel. If the plan is to update the kernel, can you send me a patch
to do that so I can test it ?

Thanks,
Guenter


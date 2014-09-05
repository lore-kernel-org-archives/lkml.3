Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaIEGqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:46:38 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:34694 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaIEGqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:46:36 -0400
X-Greylist: delayed 3229 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 02:46:36 EDT
Message-ID: <54094FA7.6000809@roeck-us.net>
Date: Thu, 04 Sep 2014 22:52:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Xuetao Guan <gxt@pku.edu.cn>
CC: linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: =?UTF-8?B?5Zue5aSN77yaIFJlOiDlm57lpI3vvJogUmU6IOWbnuWkje+8miA=?=
 =?UTF-8?B?U3RhdHVzIG9mICd1bmljb3JlMzInIGFyY2hpdGVjdHVyZSBpbiBMaW51eCBrZXI=?=
 =?UTF-8?B?bmVs?=
References: <926403536.39754.1409733179383.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <926403536.39754.1409733179383.JavaMail.root@bj-mail03.pku.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54094FAF.0057,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
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

On 09/03/2014 01:32 AM, Xuetao Guan  wrote:
>
[ ... ]

>> Please try the following patch. That seems to do it.
>> I am sure it can be improved, but it is a start.
>>
>> Thanks,
>> Guenter
>
> Thanks. I'll test it.
> BTW, Qemu codestyle is different, and tab should be replaced with blanks.
>

Here is where I am. User space code (busybox) was compiled
using the unicore toolchain available on the web.

...
serio: i8042 KBD port at 0x6eb00060,0x6eb00064 irq 22
mousedev: PS/2 mouse device common for all mice
Enable UniCore-F64 support.
Warning: unable to open an initial console.
Freeing unused kernel memory: 1156K (c0408000 - c0529000)

Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

The kernel tries to execute the init program, which fails with SIGSEGV.
I confirmed that the init program is loaded and starts to execute.

Any idea what might cause such a problem ?

Thanks,
Guenter


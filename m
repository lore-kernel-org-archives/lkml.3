Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaLAQ5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:57:41 -0500
Received: from lists.s-osg.org ([54.187.51.154]:38739 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbaLAQ5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:57:39 -0500
Message-ID: <547C9E01.9000606@osg.samsung.com>
Date: Mon, 01 Dec 2014 09:57:37 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>, Arnd Bergmann <arnd@arndb.de>
CC: Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 1/3] kcmp: Move kcmp.h into uapi
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au> <2940943.qiYEMaLEXx@wuerfel> <20141023081457.GE16267@moon>
In-Reply-To: <20141023081457.GE16267@moon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 02:14 AM, Cyrill Gorcunov wrote:
> On Thu, Oct 23, 2014 at 09:49:14AM +0200, Arnd Bergmann wrote:
>> On Thursday 23 October 2014 16:07:12 Michael Ellerman wrote:
>>> --- a/include/linux/kcmp.h
>>> +++ b/include/linux/kcmp.h
>>> @@ -1,17 +1,6 @@
>>>  #ifndef _LINUX_KCMP_H
>>>  #define _LINUX_KCMP_H
>>>  
>>> -/* Comparison type */
>>> -enum kcmp_type {
>>> -       KCMP_FILE,
>>> -       KCMP_VM,
>>> -       KCMP_FILES,
>>> -       KCMP_FS,
>>> -       KCMP_SIGHAND,
>>> -       KCMP_IO,
>>> -       KCMP_SYSVSEM,
>>> -
>>> -       KCMP_TYPES,
>>> -};
>>> +#include <uapi/linux/kcmp.h>
>>>  
>>>  #endif /* _LINUX_KCMP_H */
>>>
>>
>> If the file is empty except for the uapi include, I think it's better to
>> delete it completely. The include path logic should ensure we pick the
>> other one up.
> 
> Good point, somehow managed to miss this.
> 

Michael,

Are you planning to send v2 to address the comments?

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978

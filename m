Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaJSRcF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 13:32:05 -0400
Received: from mout.gmx.net ([212.227.15.15]:62159 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbaJSRcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 13:32:02 -0400
Message-ID: <5443F4A7.6010900@gmx.at>
Date: Sun, 19 Oct 2014 19:28:07 +0200
From: Manfred Schlaegl <manfred.schlaegl@gmx.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>
CC: Daniel Walter <dwalter@google.com>, Randy Dunlap <rdunlap@infradead.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: Remove unused bp stack-frame pointer
References: <544277C5.9030302@gmx.at> <54427C48.9050608@nod.at> <54428348.2050209@gmx.at> <54428500.6020304@nod.at> <5442862A.4090408@gmx.at> <544289F8.3020704@nod.at>
In-Reply-To: <544289F8.3020704@nod.at>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:F+0+uxLV61CjEKby+T2vnHkgCXoggxqQBWXG2VhlkTpVRT5RhLq
 WxNV7MU36UWMw/JOi53Wk2gZBXSE2eYz01OHqVK7gyUbxfyc+dOzXIrlz7xlMx9nypJZ9P0
 3OV531b1MfXEcza2t7oMec/8T1sKAeMzM/OpWrz6745hlfOFAq3BSHdAy0LBxS0BgNuxjAk
 Z376I2yZrnsNIoXXClPtQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-18 17:40, Richard Weinberger wrote:
> Am 18.10.2014 um 17:24 schrieb Manfred Schlaegl:
>> On 2014-10-18 17:19, Richard Weinberger wrote:
>>> Am 18.10.2014 um 17:12 schrieb Manfred Schlaegl:
>>>> On 2014-10-18 16:42, Richard Weinberger wrote:
>>>>> Am 18.10.2014 um 16:23 schrieb Manfred Schlaegl:
>>>>>> The pointer to bp stack-frame is no longer used. Removed it.
>>>>>
>>>>> Good catch!
>>>> Thank you.
>>>>
>>>>>
>>>>>> This also removes a corresponding compiler-warning.
>>>>>
>>>>> Which warning exactly?
>>>>
>>>> On "normal" (defconfig) builds the warning does not show up because CONFIG_FRAME_POINTER is set.
>>>> I've found the unused bp because CONFIG_FRAME_POINTER was not set in my configuration.
>>>>
>>>>   CC      arch/um/kernel/sysrq.o
>>>> arch/um/kernel/sysrq.c: In function ‘show_stack’:
>>>> arch/um/kernel/sysrq.c:32:29: warning: unused variable ‘bp’ [-Wunused-variable]
>>>
>>> Looks like my gcc need's an upgrade. :D
>>>
>>> Thanks,
>>> //richard
>>>
>>
>> I'm using gcc version 4.7.2 (Debian 4.7.2-5). -> not THAT new ;-)
> 
> With a cup of coffee applied I managed it to read your mail correctly.
> The warning triggers only with CONFIG_FRAME_POINTER=n. Now it makes sense.

Misunderstanding solved! Miracle cure caffeine ;-)

greetings
manfred


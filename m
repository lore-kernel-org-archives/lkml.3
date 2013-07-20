Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3GTAKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 20:10:08 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:12559 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3GTAKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 20:10:05 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-b8-51e9d55b67e7
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [ 00/38] 3.9.11-stable review
Thread-topic: [ 00/38] 3.9.11-stable review
Thread-index: AQHOhJVmEYdPFGTrWEWBmR0E5HnPIQ==
Date: Sat, 20 Jul 2013 00:10:02 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61746BA3@sisaex01sj>
References: <20130719052047.858393825@linuxfoundation.org>
 <B8EFE96D1287C24090BAD9D858E15E6174192D@sisaex01sj>
 <20130719192524.GB2428@kroah.com> <20130719234723.GA11456@kroah.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+wn27M1ZeBBts1LeasX8Nm0bx4PZvF
	5V1z2Cy+/nSwWLDxEaPFo7637A5sHjtn3WX3ODHjN4vH/rlr2D0+b5ILYInisklJzcksSy3S
	t0vgyti/+DJrwWzxijtdeg2Mv4S6GDk5JARMJFq3L2OBsMUkLtxbz9bFyMUhJLCMUaJl9VdG
	CKeXSWL61SPMEM58Rok5P3azg7SwCahLfH69A8wWETCW6D87ix2kiFngGJNE5/OJjCAJYQEt
	ict7z7FAFGlL/P/wng3C1pO4N+cWK4jNIqAq0XDoIFg9r4C9xMLNPVDbtjNKnNk5AayZEejA
	76fWMIHYzALiEs2tN6EOF5BYsuc8M4QtKvHy8T+goRxAtqLE9tVWEOV6Eh//3GaEsLUlnry7
	wAqxS1Dix+R7LBMYxWYhmToLScssJC2zkLQsYGRZxShWWpxcUJyUnlphqFecmFtcmpeul5yf
	u4kREntVOxjvfLU5xCjAwajEw3thxctAIdbEsuLK3EOMEhzMSiK8BWlAId6UxMqq1KL8+KLS
	nNTiQ4xMHJxSDYyMpqdmO+VKPH0+0XEj8122w71BTl+sdV8uvyKyODNTcpvfC9O07+yNs6cv
	L1kXNWXFtoS62OifQq23D8e/UtXo7HznfElp47o1tjGn3+xlCvputN+LxUex1P/mxCO5f7cv
	P/W6tZdfqnsn19WGg7rJmtP7Xrw1F3C8vOV8+YOKGQ9vnFoz5UOFEktxRqKhFnNRcSIAMecG
	ppsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 05:50 PM, Greg Kroah-Hartman wrote:
> On Fri, Jul 19, 2013 at 12:25:24PM -0700, Greg Kroah-Hartman wrote:
>> On Fri, Jul 19, 2013 at 04:45:25PM +0000, Shuah Khan wrote:
>>> On 07/19/2013 09:34 AM, Greg Kroah-Hartman wrote:
>>>> ---------------
>>>> Note, this is the LAST 3.9-stable kernel release that I will be doing.
>>>> Please move to the 3.10-stable branch as soon as possible.
>>>> ---------------
>>>>
>>>> This is the start of the stable review cycle for the 3.9.11 release.
>>>> There are 38 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Sun Jul 21 05:20:01 UTC 2013.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.11-rc1.gz
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>
>>> Greg,
>>>
>>> Build failed with the following error:
>>>
>>>     LD      ipc/built-in.o
>>>     CC [M]  fs/cifs/inode.o
>>> fs/cifs/inode.c: In function ‘cifs_all_info_to_fattr’:
>>> fs/cifs/inode.c:560:4: error: implicit declaration of function
>>> ‘cifs_dbg’ [-Werror=implicit-function-declaration]
>>> cc1: some warnings being treated as errors
>>> make[2]: *** [fs/cifs/inode.o] Error 1
>>> make[1]: *** [fs/cifs] Error 2
>>> make: *** [fs] Error 2
>>> make: *** Waiting for unfinished jobs....
>>>     CC      security/selinux/hooks.o
>>>
>>> I have CONFIG_CIFS=m in my config and CONFIG_CIFS_DEBUG is disabled.
>>> cifs_dbg() is not defined.
>>
>> Ugh, I thought I fixed that one...  I did it for the 3.4 and other
>> trees, I'll go see what I did wrong...
>
> Ok, I've now fixed this, I don't know how it got through my tests, when
> I tried it again, it failed.  Before it wasn't, odd...
>
> Anyway, there is a new -rc2 kernel patch at:
>   	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.11-rc2.gz
>
> If you could test that out, I would appreciate it, to ensure I didn't do
> anything stupid with this one too.
>
> Ick, handling 4 kernels at once really takes its toll on me, this was
> not a good review cycle...
>
> thanks,
>
> greg k-h
>

Greg,

rc2 compiled on x86-64. I will run cross-compile tests and boot tests 
later on today or tomorrow morning and report the results.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658

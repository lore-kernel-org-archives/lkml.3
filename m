Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaB1Wpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:45:42 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:56822 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaB1Wpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:45:40 -0500
X-AuditID: cbfec37a-b7fc06d00000555a-69-5311119372e2
Message-id: <53111190.4020907@samsung.com>
Date: Fri, 28 Feb 2014 15:45:36 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: ly80toro@cip.cs.fau.de, andy.grover@gmail.com, valentina.manea.m@gmail.com,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 1/3] staging/usbip: add uapi header to export usbip kernel
 interfaces
References: <cover.1393542201.git.shuah.kh@samsung.com>
 <10c9784313c5bafc6410b95cb3b569d5925eeaaa.1393542201.git.shuah.kh@samsung.com>
 <20140228221558.GA17000@kroah.com>
In-reply-to: <20140228221558.GA17000@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.6]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t9hP93JgoLBBs9fSlu8XbqT2WLPmV/s
	Fs2L17NZXN41h81i0bJWZotn13Isvv50sHh3aS67A4fHkgt3mDzu7TvM4rFz1l12j/1z17B7
	fN4kF8AaxWWTkpqTWZZapG+XwJVxf8pspoJZ3BWTbh9hamD8xtHFyMkhIWAisezHcxYIW0zi
	wr31bF2MXBxCAssYJT5NvMMI4fQySdx4uhXK2cAoceXIUrAWXgEtiR1NDWwgNouAqsSqw+vA
	4mwC6hKfX+9gB7GFBOQkmpasZgaxRQUiJF6dnQjVKyjxY/I9MFtEQEPi5dFbYDazwENGifsX
	akFsYYFoiT+T77JALF7LKDGlsZ0RJMEpoC9x4vs5VogGa4mVk7YxQtjyEpvXvGWGWKws8efy
	KSaI3xQkHl1tZZ/AKDILye5ZSNpnIWlfwMi8ilGstDi5oDgpPbXCUK84Mbe4NC9dLzk/dxMj
	JKaqdjDe+WpziFGAg1GJh1dikUCwEGtiWXFl7iFGCQ5mJRHeCdeBQrwpiZVVqUX58UWlOanF
	hxiZODilGhjrEstOs899rLbK5mSYZfOCIPtvTx4Ynk6eU7HWt23FsoYuzw01GZ1ez13Wnl66
	t2Ari0blH/39Dhu3bgxiOJvYXLUl7vvqNfl/BAP+cWteKVq2+bapsf6UGUeaxRaVTONKz1je
	tGXRG/mNRfJbxL6lsd8XT7G/rmqdVBwve1fvY9uqaTkGnexKLMUZiYZazEXFiQDAU66rhwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 03:15 PM, Greg KH wrote:
> On Thu, Feb 27, 2014 at 05:27:25PM -0700, Shuah Khan wrote:
>> usbip userspace has duplicated enum definition to report usbip device
>> status maintained by the kernel. Adding an usbip uapi header file will
>> define the kernel - userspace interface for this device status.
>>
>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>> ---
>>   include/uapi/linux/Kbuild  |    1 +
>>   include/uapi/linux/usbip.h |   26 ++++++++++++++++++++++++++
>>   2 files changed, 27 insertions(+)
>>   create mode 100644 include/uapi/linux/usbip.h
>
> Staging code should be self-contained within drivers/staging/
>
> Now I know that a bunch of people are now working on this codebase, and
> hopefully it will finally get moved out of staging someday soon, but
> until then, I can't add this file in this location, sorry.

That makes sense.

>
> Look at how the drivers/staging/android code handles the uapi files, you
> should try doing that instead.
>

I will take a look at how android is handling uapi files and redo this 
patch series and resend it. Hope everybody is ok with the code itself, 
just the location of the uapi file is the issue, if not please let me 
know and give me feedback on the approach.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658

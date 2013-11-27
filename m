Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab3K0EWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 23:22:14 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64403 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3K0EWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 23:22:12 -0500
Message-ID: <529573F6.9080106@gmail.com>
Date: Wed, 27 Nov 2013 12:24:22 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Joe Perches <joe@perches.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rkuo <rkuo@codeaurora.org>, hans.verkuil@cisco.com,
        m.chehab@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] drivers: staging: media: go7007: go7007-usb.c use
 pr_*() instead of dev_*() before 'go' initialized in go7007_usb_probe()
References: <528AEFB7.4060301@gmail.com> <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com> <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com> <52956442.50001@gmail.com> <1385522475.18487.34.camel@joe-AO722> <529569A5.1020008@gmail.com> <52956B78.6050107@gmail.com> <20131127040338.GB23930@kroah.com>
In-Reply-To: <20131127040338.GB23930@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 12:03 PM, Greg KH wrote:
> On Wed, Nov 27, 2013 at 11:48:08AM +0800, Chen Gang wrote:
>> dev_*() assumes 'go' is already initialized, so need use pr_*() instead
>> of before 'go' initialized. Related warning (with allmodconfig under
>> hexagon):
>>
>>     CC [M]  drivers/staging/media/go7007/go7007-usb.o
>>   drivers/staging/media/go7007/go7007-usb.c: In function 'go7007_usb_probe':
>>   drivers/staging/media/go7007/go7007-usb.c:1060:2: warning: 'go' may be used uninitialized in this function [-Wuninitialized]
>>
>> Also remove useless code after 'return' statement.
> 
> This should all be fixed in my staging-linus branch already, right?  No
> need for this anymore from what I can tell, sorry.
> 

That's all right (in fact don't need sorry).  :-)

And excuse me, I am not quite familiar upstream kernel version merging
and branches. Is it still better/suitable/possible to sync some bug fix
patches from staging brach to next brach?


Thanks.
-- 
Chen Gang

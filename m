Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab3GKLQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:16:04 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:37462 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127Ab3GKLQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:16:03 -0400
Message-ID: <51DE9382.4060108@schinagl.nl>
Date: Thu, 11 Jul 2013 13:14:10 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        khali@linux-fr.org
Subject: Re: [PATCH v2 0/7] Driver core and sysfs changes for attribute groups
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org> <1373502965-1683-1-git-send-email-gregkh@linuxfoundation.org> <20130711052357.GB16441@roeck-us.net> <20130711062834.GB15254@kroah.com>
In-Reply-To: <20130711062834.GB15254@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-07-13 08:28, Greg Kroah-Hartman wrote:
> On Wed, Jul 10, 2013 at 10:23:57PM -0700, Guenter Roeck wrote:
>> On Wed, Jul 10, 2013 at 05:35:58PM -0700, Greg Kroah-Hartman wrote:
>>> Hi all,
>>>
>>> Here's the second iteration of the patchset to add better attribute
>>> group support to the driver core and sysfs.
>>>
>>> I've tested these (shocker!) and everything works fine with them (I'm
>>> sending this from Linus's latest kernel with these 7 on top of it.)
>>>
>>> I'd like to send these to Linus for 3.11 unless someone objects.
>>>
>>> Oliver, please use this series instead of the last one, it has fixes
>>> that Guenter pointed out that would have crashed your box at boot.
It still crashes, but haven't read back all. I do have some extra helper 
macro's patch incoming once i make sure it boots.

(it boots but segfaults) give me a few hours to report back.

oliver
>>>
>>> changes from v2:
>>> 	- actually boots
>>> 	- 7th patch added properly
>>> 	- added BUS_ATTR, CLASS_ATTR, and DRIVER_ATTR RW and RO macros
>>> 	  to help with converting code to use attributes properly.
>>>
>> Looks good this time. And, yes, it does boot and work, including patch #7.
>> Feel free to add
>>
>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>>
>> and if you like
>>
>> Tested-by: Guenter Roeck <linux@roeck-us.net>
>>
>> to the series.
>
> Thanks for the testing and review, I'll add this when I commit them
> sometime next week.
>
> greg k-h
>


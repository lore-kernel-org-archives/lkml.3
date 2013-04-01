Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab3DAWxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:53:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:50354 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759332Ab3DAWxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:53:22 -0400
Message-ID: <515A01D3.6070601@infradead.org>
Date: Mon, 01 Apr 2013 14:53:23 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Andy King <acking@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [PATCH] misc/vmw_vmci: VMWARE_VMCI depends on NET
References: <1364791439-28396-1-git-send-email-linux@roeck-us.net> <20130401192939.GA31983@kroah.com> <20130401200235.GA14969@roeck-us.net> <20130401201152.GA29283@kroah.com> <20130401221730.GA28799@roeck-us.net>
In-Reply-To: <20130401221730.GA28799@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/13 15:17, Guenter Roeck wrote:
> On Mon, Apr 01, 2013 at 01:11:52PM -0700, Greg Kroah-Hartman wrote:
>> On Mon, Apr 01, 2013 at 01:02:35PM -0700, Guenter Roeck wrote:
>>> On Mon, Apr 01, 2013 at 12:29:39PM -0700, Greg Kroah-Hartman wrote:
>>>> On Sun, Mar 31, 2013 at 09:43:59PM -0700, Guenter Roeck wrote:
>>>>> Fix:
>>>>>
>>>>> ERROR: "memcpy_toiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
>>>>> ERROR: "memcpy_fromiovec" [drivers/misc/vmw_vmci/vmw_vmci.ko] undefined!
>>>>>
>>>>> Both functions are defined in the core networking code.
>>>>
>>>> This is already in linux-next, thanks.
>>>>
>>> Uuh ... and I submitted it. Sorry for the noise.
>>>
>>> Any chance to apply this to 3.9-rc ? It causes a bunch of unnecessary
>>> nightly build errors for me.
>>
>> As it's a configuration that no "real" user would ever hit, it's not
>> really 3.9 material, sorry.
>>
> Fair enough.
> 
> On the other side, value of "make randconfig" has been reduced significantly
> compared to earlier times, when patches like this tended to be accepted into
> release candidates. Until a few releases ago, "make randconfig" usually passed
> at least for main targets by the time a kernel was relased. With this no longer
> the case, fewer and fewer people will look into nightly or per-rc build results
> and provide patches. This in turn will likely reduce reliability, as real
> problems are more and more hidden among all the "unreal" build errors.
> In addition to that, more and more people will end up with non-buildable
> configurations and have to spend time trying to figure out why exactly
> a build failed.
> 
> But maybe this is all my imagination, so feel free to just ignore my ranting ;).


My experiences have been that Linus is not opposed to taking such
build fixes at almost any time.  IOW, I think that Greg is being more
strict than Linus would be, but Greg is the misc/ maintainer, so it's
his call.



-- 
~Randy

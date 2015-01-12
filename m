Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbbALVK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:10:27 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:35821 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbbALVK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:10:26 -0500
Message-ID: <54B43840.4010303@candelatech.com>
Date: Mon, 12 Jan 2015 13:10:24 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.19.0-rc4+ fails to compile, missing 'usr/missing-syscalls'
References: <54B429B6.6070809@candelatech.com> <20150112205550.GA10471@roeck-us.net>
In-Reply-To: <20150112205550.GA10471@roeck-us.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 12:55 PM, Guenter Roeck wrote:
> On Mon, Jan 12, 2015 at 12:08:22PM -0800, Ben Greear wrote:
>>
>> Any idea what is wrong?
>>
>> -rc3 compiled ok, then I rebased just now, and get this:
>>
> My auto-builders are all happy, with no build or qemu failures.
> Did you try "make mrproper" prior to rebuilding ?

yes, and blew away .ccache too.

But, I saw something weird like git suddenly got confused a bit earlier,
so I will re-clone and try again in case the 'reset --hard HEAD' didn't
clean up as much as I had hoped.

Thanks,
Ben

> 
> Guenter
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


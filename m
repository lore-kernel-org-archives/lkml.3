Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965607AbaH1CXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:23:40 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36381 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbaH1CXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:23:38 -0400
Message-ID: <53FE9289.3050809@gmail.com>
Date: Thu, 28 Aug 2014 10:23:05 +0800
From: Janet Liu <jianhua.ljh@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Re: [PATCH] staging:lustre:lnet: lib-md.c fix checkpath
 warnings and errors.
References: <20140827012245.GA26157@kroah.com> <53FE91E1.1020006@qq.com>
In-Reply-To: <53FE91E1.1020006@qq.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2014 10:20 AM, Janet Liu wrote:
>
>
>
> -------- Original Message --------
> Subject: Re: [PATCH] staging:lustre:lnet: lib-md.c fix checkpath
> warnings and errors.
> Date: Tue, 26 Aug 2014 18:22:45 -0700
> From: Greg KH <gregkh@linuxfoundation.org>
> To: Janet Liu <janetliu526@qq.com>
> CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
>
> On Mon, Aug 25, 2014 at 01:18:54AM +0800, Janet Liu wrote:
>> Sliences the following warning and error:
>>
>>   WARNING: line over 80 characters
>>   WARNING: space prohibited between function name and open parenthesis
>> '('
>>   ERROR: do not use C99 // comments
>>   ERROR: trailing statements should be on next line
>
> You changed 4 things, in one patch :(
>
> Also, you sent 4 different patches, which one is correct?
>
> Please only do one thing per patch and please resend with the one that
> you wish to have reviewed.
>
> thanks,
>
> greg k-h
>
>
Hi Greg,

I'm very sorry for having troubled you.

The latest one is correct. It is send by my gmail box.

The first two is sent by this mailbox(janetliu526@qq.com) and is 
rejected by linux-kernel@vger.kernel.org.

The third is tested by dan.carpenter@oracle.com, he told me it broke 
build. So I fixed and send the fourth.

Those are all codestyle issue.

regards,
janet

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaDCX3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 19:29:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48872 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbaDCX3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 19:29:37 -0400
Message-ID: <533DEEDC.3040402@gmail.com>
Date: Fri, 04 Apr 2014 01:29:32 +0200
From: Sherif <shehabaldin.sherif@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, silentquote@gmail.com
Subject: Re: [PATCH 7/9] driver: staging: wlan-ng: Fixed white spaces issues
References: <1396509209-3074-1-git-send-email-shehabaldin.sherif@gmail.com> <20140403074511.GY6991@mwanda> <533D1A01.30304@gmail.com> <20140403093855.GG6991@mwanda> <533D2D17.6060408@gmail.com> <20140403094829.GI6991@mwanda>
In-Reply-To: <20140403094829.GI6991@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's because I didn't build this source tree before. Had to build it 
first and now I can build the module.

I will regenerate the patches and send them by tomorrow hopefully. Hope 
to do it right this time. :)

On 04/03/2014 11:48 AM, Dan Carpenter wrote:
> On Thu, Apr 03, 2014 at 11:42:47AM +0200, Sherif wrote:
>> Yes I enabled it:
>> $ grep PRISM2_USB .config
>> CONFIG_PRISM2_USB=m
>>
>> But still getting the same output:
>> $ make M=drivers/staging/wlan-ng/
>>    Building modules, stage 2.
>>    MODPOST 0 modules
>>
>
> That's very odd.  It works for me.  I don't know what to tell you.
>
> regards,
> dan carpenter
>

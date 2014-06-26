Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbaFZBvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 21:51:47 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:54282 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbaFZBvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 21:51:45 -0400
MIME-Version: 1.0
In-Reply-To: <1403741362.28663.12.camel@joe-AO725>
References: <CAJKoSVRLvPe+5tae=buV3j12L612tdaYAWMT303GO71NF-w27g@mail.gmail.com>
	<1403741362.28663.12.camel@joe-AO725>
Date: Thu, 26 Jun 2014 09:51:44 +0800
Message-ID: <CAJKoSVStb88Y-6r0bTG7bgXjRCujd-p9wM09L3_s-Nvsk4GLgw@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: wlan-ng/hfa384x_usb.c: remove return
 statements for void function
From: Cheng-Wei Lee <lee.rhapsody@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>,
        Avinash Kumar <avi.kp.137@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Thanks for your kindly reply.
I'll submit patch again.

Many thanks,
Quentin

2014-06-26 8:09 GMT+08:00, Joe Perches <joe@perches.com>:
> On Wed, 2014-06-25 at 23:35 +0800, Cheng-Wei Lee wrote:
>> This patch fixes the following checkpatch.pl issues in hfa384x_usb.c:
>> WARNING: Missing a blank line after declarations
>
> Still has a mismatch between subject and code
>
>> diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c
> []
>> @@ -3533,7 +3533,7 @@ static void hfa384x_usbin_rx(wlandevice_t
>> *wlandev, struct sk_buff *skb)
>>  	}
>>
>>  done:
>> -	return;
>> +	pr_debug("hfa384x_usbin_rx: done\n");
>
> I suggest you just leave the return,
>
> Any checkpatch suggestion this was needed was a false
> positive that should be resolved by this patch:
>
> http://article.gmane.org/gmane.linux.kernel/1728891
>
>
>

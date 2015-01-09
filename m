Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbbAIEeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 23:34:12 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:41378 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbbAIEeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 23:34:11 -0500
Message-ID: <54AF59F3.9080200@roeck-us.net>
Date: Thu, 08 Jan 2015 20:32:51 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] hwmon: (ina2xx) implement update_interval attribute for
 ina226
References: <1420734313-24546-1-git-send-email-bgolaszewski@baylibre.com>	<20150108170519.GA30248@roeck-us.net> <CAMpxmJVmyVr7PJGaAkujacpWyRXew=37bz-PsURf7_-dTptBSw@mail.gmail.com>
In-Reply-To: <CAMpxmJVmyVr7PJGaAkujacpWyRXew=37bz-PsURf7_-dTptBSw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54AF5A50.0021,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 10:14 AM, Bartosz Golaszewski wrote:
> 2015-01-08 18:05 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
>> What is the purpose of multiplying the calculated average by 2 ?
>
> The comment above says:
>
>> +     /*
>> +      * Add bus and shunt voltage conversion times and multiple them
>> +      * by the averaging rate. Return the result in milliseconds.
>> +      */
>
> Since both conversion times are the same and equal
> INA226_CONV_TIME_DEFAULT I just multiplied it by 2 - I thought it was
> clear enough. I'll fix that in the next iteration.
>

Sorry, still don't get it. I must be a bit slow today ;-)

Guenter



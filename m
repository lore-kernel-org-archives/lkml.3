Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbbA0OXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:23:42 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:41081 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbbA0OXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:23:40 -0500
Message-ID: <54C79F57.9050902@roeck-us.net>
Date: Tue, 27 Jan 2015 06:23:19 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>,
        Robert Rosengren <robert.rosengren@axis.com>
CC: lm-sensors <lm-sensors@lm-sensors.org>, Johan Adolfsson <johana@axis.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: (ads7828) Make sample interval configurable
References: <1421409922-28299-1-git-send-email-robert.rosengren@axis.com>	 <54B92596.2040206@roeck-us.net> <20150116183020.GA6262@roeck-us.net>	 <54C74567.9020201@axis.com> <1422355070.4499.136.camel@chaos.site>
In-Reply-To: <1422355070.4499.136.camel@chaos.site>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54C79F5A.0215,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
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

On 01/27/2015 02:37 AM, Jean Delvare wrote:
> Hi Robert,
>
> Le Tuesday 27 January 2015 à 08:59 +0100, Robert Rosengren a écrit :
>> On 01/16/2015 07:30 PM, Guenter Roeck wrote:
>>> I sent a couple of patches a minute ago which should take care of the issue.
>>> Would be great if you can test it.
>> I applied the v2 versions of the patches for a quick test, but it was
>> not successful. Haven't done any further investigation on what the
>> problem might be, but when trying to read the sysfs driver I get "read
>> error: No such device or address".
>>
>> The sysfs path have moved with the REGMAP settings, from
>> /sys/bus/i2c/devices/<x>/in0_input to
>> /sys/bus/i2c/devices/<x>/hwmon/hwmon0/in0_input.
>
> This is expected, shouldn't be an issue if you are using a
> libsensors-based application with a recent enough version of libsensors.
>

Odd though, thinking about it, since the move was done with a separate
patch, not with the regmap patch.

Guenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbbAKQxC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 11:53:02 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:55024 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbAKQw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 11:52:59 -0500
Message-ID: <54B2AA69.80305@roeck-us.net>
Date: Sun, 11 Jan 2015 08:52:57 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Martin Kepplinger <martink@posteo.de>
CC: peterz@infradead.org, mingo@kernel.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] hwmon: jc42: use bitops' sign_extend16
References: <1418660317-21750-1-git-send-email-martink@posteo.de> <1418660317-21750-4-git-send-email-martink@posteo.de> <20141215212948.GA23765@roeck-us.net> <548FDC85.3060400@posteo.de> <54B251A7.3000403@posteo.de>
In-Reply-To: <54B251A7.3000403@posteo.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54B2AA6B.00A0,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 01/11/2015 02:34 AM, Martin Kepplinger wrote:
> Am 2014-12-16 um 08:17 schrieb Martin Kepplinger:
>> Am 2014-12-15 um 22:29 schrieb Guenter Roeck:
>>> On Mon, Dec 15, 2014 at 05:18:34PM +0100, Martin Kepplinger wrote:
>>>> ---
>>>
>>> Some description would be nice. Also, please consider adding
>>> relevant subsystem mailing lists and maintainers to your patches.
>>>
>>
>> I shouldn't have added the Signed-off-by line to some of them. Sorry.
>>
>> The driver-patches are meant to be examples of what can be changed if
>> the sign_extend functions are added. I don't know if they are taken and
>> planned to post the driver patches (probably more) thereafter, and of
>> course to the relevant people.
>
> Is this sign_extendXX() set of functions considered to be added to
> bitops.h ?
>
> Just checking if I can prepare some driver-patches (the ones I posted
> are just examples, meant to be re-sent to relevant maintainers when it's
> time), or not.
>

You should probably ask the question as response to patch 1/6.

In general, it might be useful to send example patches like this one as RFC.
Sending it as real patch and then saying "it is just an example" may result
in the entire series being ignored. This is not a matter of Signed-off or not
(originally I didn't even understand what you wanted to say with your reply),
but a matter of a non-misleading headline.

Thanks,
Guenter


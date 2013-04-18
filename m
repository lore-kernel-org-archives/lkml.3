Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936464Ab3DRTTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 15:19:08 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3943 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab3DRTTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 15:19:06 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <51704721.2020001@broadcom.com>
Date: Thu, 18 Apr 2013 21:18:57 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329
 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Marcel Holtmann" <marcel@holtmann.org>
cc: "Bing Zhao" <bzhao@marvell.com>,
        "linux-netdev@vger.kernel.org" <linux-netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul Stewart" <pstew@chromium.org>
Subject: Re: [PATCH] net-sysfs: Add entry for nl80211 interface type
References: <1366236369-543-1-git-send-email-bzhao@marvell.com>
 <0156C538-4175-47E9-B667-C2127CBEF3EB@holtmann.org>
 <477F20668A386D41ADCC57781B1F70430D9E05713A@SC-VEXCH1.marvell.com>
 <CD07F4FD-7136-44EA-A39C-5AB660726BDE@holtmann.org>
In-Reply-To: <CD07F4FD-7136-44EA-A39C-5AB660726BDE@holtmann.org>
X-WSS-ID: 7D6E9A603944365876-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 09:10 PM, Marcel Holtmann wrote:
> Hi Bing,
>
>>>> Add a "wireless/nl80211_iftype" entry in the net device sysfs
>>>> file structure to indicate the mode of the wireless device so
>>>> it can be discovered easily from userspace.
>>>
>>> I do question a little bit the usefulness for this one.
>>> It would only work on netdev and on wdev devices.
>>
>> It's true. That's why the new sysfs entry is added in the 'wireless' placeholder.
>>
>> /sys/class/net/ethX/wireless/
>>
>> For non-wireless dev, this won't apply.
>
> I have to correct myself. I meant it does NOT work for wdev. Please just go with nl80211 for this kind of information. It is the right way to handle it. Not some sysfs file.
>

I wanted to correct you on P2P but that would be diverging from the real 
message. Totally agreeing. Why add another user-space API when the 
nl80211 API can provide the information.

Gr. AvS



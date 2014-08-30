Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaH3DQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 23:16:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:6183 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbaH3DQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 23:16:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,429,1406617200"; 
   d="scan'208";a="591988340"
Message-ID: <540141F0.7080207@linux.intel.com>
Date: Sat, 30 Aug 2014 11:16:00 +0800
From: "Lu, Baolu" <baolu.lu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USB: Add device quirk for ASUS T100 Base Station
 keyboard
References: <1409286391-2854-1-git-send-email-baolu.lu@linux.intel.com> <54006B0A.2050902@cogentembedded.com>
In-Reply-To: <54006B0A.2050902@cogentembedded.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 8/29/2014 7:59 PM, Sergei Shtylyov wrote:
> Hello.
>
> On 8/29/2014 8:26 AM, Lu Baolu wrote:
>
>> This full-speed USB device generates spurious remote wakeup event
>> as soon as USB_DEVICE_REMOTE_WAKEUP feature is set. As the result,
>> Linux can't enter system suspend and S0ix power saving modes once
>> this keyboard is used.
>
>> This patch tries to introduce USB_QUIRK_IGNOR_REMOTE_WAKEUP quirk.
>
>    Why not IGNORE? This doesn't look like a big save...

Sure, will change it.

>
>> With this quirk set, wakeup capability will be ignored during
>> device configure.
>
>> This patch could be back-ported to kernels as old as 2.6.39.
>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>
> WBR, Sergei
>


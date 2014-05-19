Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaESJXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:23:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:39350 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbaESJXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:23:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,866,1392192000"; 
   d="scan'208";a="513813159"
Message-ID: <5379CD91.2080709@intel.com>
Date: Mon, 19 May 2014 17:23:29 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: rjw@rjwysocki.net, mika.westerberg@linux.intel.com, awilliam@redhat.com,
        lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 6/9] I2C: Add smbus word/block process call helper
 function
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com> <1398695268-28645-1-git-send-email-tianyu.lan@intel.com> <1398695268-28645-7-git-send-email-tianyu.lan@intel.com> <20140517102110.GB2602@katana> <53776B32.8010400@intel.com> <20140517171759.GB2597@katana>
In-Reply-To: <20140517171759.GB2597@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2014 01:17 AM, Wolfram Sang wrote:
>
>>> BTW what were your test scenarios for these functions and smbus quick?
>>>
>>
>>  From ACPI spec, Read/Write quick and Word/Block process call
>> protocol will be used by Bios ACPI code. But so far, I don't find
>> such machines. So these functions has not been tested.
>
> Uh oh, I have some trouble adding untested code. Can't we add until we
> have a user to verify it?

Ok. I will remove these patches from this patchset since currently there are no 
users.

>
> BTW I have to review the other patches later, so please wait before
> resending the series.
>


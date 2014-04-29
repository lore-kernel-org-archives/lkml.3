Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaD2CDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:03:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:40376 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbaD2CC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:02:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,948,1389772800"; 
   d="scan'208";a="425158089"
Message-ID: <535F0666.1090409@intel.com>
Date: Tue, 29 Apr 2014 09:54:46 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: wsa@the-dreams.de, mika.westerberg@linux.intel.com, awilliam@redhat.com,
        lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 0/9] I2C ACPI operation region handler support
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com> <1398695268-28645-1-git-send-email-tianyu.lan@intel.com> <43726986.W0L99n76oE@vostro.rjw.lan>
In-Reply-To: <43726986.W0L99n76oE@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年04月29日 06:51, Rafael J. Wysocki wrote:
> On Monday, April 28, 2014 10:27:39 PM Lan Tianyu wrote:
>> ACPI 5.0 spec(5.5.2.4.5) defines GenericSerialBus(i2c, spi, uart) operation
>> region. It allows ACPI aml code able to access such kind of devices to
>> implement some ACPI standard method.
>>
>> On the Asus T100TA, Bios use GenericSerialBus operation region to access
>> i2c device to get battery info. So battery function depends on the I2C
>> operation region support. Here is the bug link.
>> https://bugzilla.kernel.org/show_bug.cgi?id=69011
>>
>> This patchset is to add I2C ACPI operation region handler support.
>>
>> Change Since V1:
>>        Fix some code style and memory leak issues in Patch 7
> 
> Is it the only patch that has changed from v1?


I also remove a redundant semicolon in the PATCH 8. Sorry. I didn't
notice these patches are already in your tree. I will produce divergence
patches based on your bleeding-edge branch.


> 
> Rafael
> 


-- 
Best regards
Tianyu Lan

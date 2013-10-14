Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab3JNMo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:44:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:51302 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab3JNMo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:44:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,492,1378882800"; 
   d="scan'208";a="410602018"
Message-ID: <525BE745.6000305@linux.intel.com>
Date: Mon, 14 Oct 2013 15:44:53 +0300
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>, rjw@sisk.pl,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ACPI: add module autoloading support for ACPI enumerated
 devices
References: <1381741834-7334-1-git-send-email-rui.zhang@intel.com>  <20131014101423.GE3521@intel.com> <1381749388.2034.28.camel@rzhang1-mobl4>
In-Reply-To: <1381749388.2034.28.camel@rzhang1-mobl4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 10/14/2013 02:16 PM, Zhang Rui wrote:
> On Mon, 2013-10-14 at 13:14 +0300, Mika Westerberg wrote:
>> For the three patches.
>>
>> I wonder if we should do the same for SPI bus as well?
>>
> yes, you are right.
> Actually, I should check for buses that supports
> acpi_driver_match_device() and fix them all.
> Will add it in next version.
>
You could have my pre- "Tested-by: Jarkko Nikula 
<jarkko.nikula@linux.intel.com>".

With your set I see bunch of failing modprobe calls from udev for 
i2c:INTABCD:xy and platform:INTDCBA:xy modaliases gone.

-- 
Jarkko

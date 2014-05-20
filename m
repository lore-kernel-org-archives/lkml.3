Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaETJP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:15:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:64152 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaETJPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:15:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,873,1392192000"; 
   d="scan'208";a="514675011"
Message-ID: <537B1D45.40705@linux.intel.com>
Date: Tue, 20 May 2014 17:15:49 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: linus.walleij@linaro.org, gnurou@gmail.com, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, bin.yang@intel.com
Subject: Re: [PATCH] gpio: Add support for Intel SoC PMIC (Crystal Cove)
References: <1400082247-24168-1-git-send-email-lejun.zhu@linux.intel.com> <20140519103933.GK2067@lahna.fi.intel.com> <20140520083046.GD1651@lahna.fi.intel.com>
In-Reply-To: <20140520083046.GD1651@lahna.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/20/2014 4:30 PM, Mika Westerberg wrote:
> On Mon, May 19, 2014 at 01:39:33PM +0300, Mika Westerberg wrote:
>> On Wed, May 14, 2014 at 11:44:07PM +0800, Zhu, Lejun wrote:
>>> Devices based on Intel SoC products such as Baytrail have a Power
>>> Management IC. In the PMIC there are subsystems for voltage regulation,
>>> A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called
>>> Crystal Cove.
>>>
>>> This patch adds support for the GPIO function in Crystal Cove.
>>
>> I have few comments as well in addition to comments from Linus and
>> Alexandre.
> 
> One more thing, I just remembered. The crystal cove GPIO driver is
> supposed to provide ACPI Operation Regions to the ASL code so you need
> to make sure you have ACPI handle associated with the device before you
> register your driver to the GPIO core.
> 

ACPI OpRegions is still under work, and will be submitted separately.
I'll fix the rest in v2. Thank you.

Best Regards
Lejun


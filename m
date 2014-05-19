Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaESBqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 21:46:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:54160 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaESBqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 21:46:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,864,1392192000"; 
   d="scan'208";a="513651924"
Message-ID: <5379626A.9020203@linux.intel.com>
Date: Mon, 19 May 2014 09:46:18 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>, aaron.lu@intel.com
CC: linus.walleij@linaro.org, gnurou@gmail.com, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, bin.yang@intel.com
Subject: Re: gpio: Add support for Intel SoC PMIC (Crystal Cove)
References: <1400082247-24168-1-git-send-email-lejun.zhu@linux.intel.com> <20140516174619.GA1471@emlix.com>
In-Reply-To: <20140516174619.GA1471@emlix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/17/2014 1:46 AM, Daniel Glöckner wrote:
> Hi Lejun,
> 
> On Wed, May 14, 2014 at 11:44:07PM +0800, Zhu, Lejun wrote:
>> This patch adds support for the GPIO function in Crystal Cove.
> 
> in our device ACPI makes use of "virtual" GPIOs that have numbers from
> 0x20 to 0x5E to change various bits in the PMIC. Do you know if this
> is officially supported by the INT33FD ACPI device or if it is a
> vendor hack?
> 
>   Daniel
> 

Hi, sorry I'm quite familiar with ACPI. I know Aaron is looking at the
possibility to use these pins in Linux ACPI, but so far we don't have
any code.

Best Regards
Lejun

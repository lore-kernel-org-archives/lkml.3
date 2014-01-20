Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbaATHKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 02:10:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:38378 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaATHKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 02:10:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="467597730"
Message-ID: <52DCCBDD.8000209@linux.intel.com>
Date: Mon, 20 Jan 2014 09:10:21 +0200
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Zhang Rui <rui.zhang@intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com,
        grant.likely@linaro.org, mika.westerberg@linux.intel.com,
        grant.likely@secretlab.ca
Subject: Re: [PATCH 3/4] fix module autoloading for ACPI enumerated devices
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com> <1389689198-2641-4-git-send-email-rui.zhang@intel.com> <20140116122704.GD2617@katana> <1389877509.3010.15.camel@rzhang1-mobl4> <20140116194651.GO17314@sirena.org.uk> <52D8DDD4.10704@linux.intel.com> <20140117155708.GS17314@sirena.org.uk>
In-Reply-To: <20140117155708.GS17314@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 05:57 PM, Mark Brown wrote:
> On Fri, Jan 17, 2014 at 09:37:56AM +0200, Jarkko Nikula wrote:
>> Sidenote: actually this modalias/module loading issue is different
>> and not related to stable ACPI i2c/spi slave device names.
> Oh, I'd been under the impression that it was the rewrite that was
> triggering this?
IIRC issue has been there since when ACPI slave device support was added.

I have a partial fix for it in cf9eb39c6f7b ("spi: Fix modalias for ACPI 
enumerated SPI devices") and when doing similar change for i2c Rui 
pointed me that he has a better fix that takes care of _CID string and 
platform code too.

-- 
Jarkko

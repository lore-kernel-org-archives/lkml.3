Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaAQHiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 02:38:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:30249 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaAQHiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 02:38:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="440272514"
Message-ID: <52D8DDD4.10704@linux.intel.com>
Date: Fri, 17 Jan 2014 09:37:56 +0200
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
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com> <1389689198-2641-4-git-send-email-rui.zhang@intel.com> <20140116122704.GD2617@katana> <1389877509.3010.15.camel@rzhang1-mobl4> <20140116194651.GO17314@sirena.org.uk>
In-Reply-To: <20140116194651.GO17314@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 09:46 PM, Mark Brown wrote:
> On Thu, Jan 16, 2014 at 09:05:09PM +0800, Zhang Rui wrote:
>> On Thu, 2014-01-16 at 13:27 +0100, Wolfram Sang wrote:
>> This seems a gap to me but I'm not 100% sure.
>> I saw Grant Likely introduced the OF style MODALIAS to platform bus, and
>> OF style registration/binding to i2c bus, maybe he has an answer for
>> this.
> This is needed for ACPI because we rewrite the device names to give us
> stable names.  With OF for I2C and SPI nothing bus specific is done that
> affects this stuff so the default behaviour works.
Sidenote: actually this modalias/module loading issue is different and 
not related to stable ACPI i2c/spi slave device names.

-- 
Jarkko

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaF3BeA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 21:34:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:23244 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbaF3Bd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 21:33:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,572,1400050800"; 
   d="scan'208";a="555038253"
Message-ID: <53B0BE37.7010103@intel.com>
Date: Mon, 30 Jun 2014 09:32:39 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: rjw@rjwysocki.net, mika.westerberg@linux.intel.com, awilliam@redhat.com,
        lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V3 5/5] I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI
 config
References: <1400590764-11108-1-git-send-email-tianyu.lan@intel.com> <1400590764-11108-6-git-send-email-tianyu.lan@intel.com> <20140627110341.GD2641@katana>
In-Reply-To: <20140627110341.GD2641@katana>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年06月27日 19:03, Wolfram Sang wrote:
> On Tue, May 20, 2014 at 08:59:24PM +0800, Lan Tianyu wrote:
>> Clean up ACPI related code in the i2c core and add CONFIG_I2C_ACPI
>> to enable I2C ACPI code.
>>
>> Current there is a race between removing I2C ACPI operation region
>> and ACPI AML code accessing. So make i2c core built-in if CONFIG_I2C_ACPI
>> is set.
>>
>> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> 
> Applied to for-next, thanks!
> 

Great. Thanks :)


-- 
Best regards
Tianyu Lan

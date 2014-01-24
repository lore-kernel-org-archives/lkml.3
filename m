Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaAXRzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:55:17 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51564 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaAXRzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:55:15 -0500
Message-ID: <52E2A901.4050707@codeaurora.org>
Date: Fri, 24 Jan 2014 12:55:13 -0500
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Feng Kan <fkan@apm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V4 5/5] Documentation: power: reset: Add documentation
 for generic SYSCON reboot driver
References: <1390504801-24483-1-git-send-email-fkan@apm.com> <1390504801-24483-6-git-send-email-fkan@apm.com> <20140124113920.GF814@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140124113920.GF814@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 06:39 AM, Mark Rutland wrote:
> On Thu, Jan 23, 2014 at 07:20:01PM +0000, Feng Kan wrote:
>> Add documentation for generic SYSCON reboot driver.
>>
>> Signed-off-by: Feng Kan <fkan@apm.com>
>> ---
>>  .../bindings/power/reset/syscon-reboot.txt         |   16 ++++++++++++++++
>>  1 files changed, 16 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
>>
>> diff --git a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
>> new file mode 100644
>> index 0000000..e9eb1fe
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
>> @@ -0,0 +1,16 @@
>> +Generic SYSCON mapped register reset driver
> 
> Bindings should describe hardware, not drivers.

How is this different than what's done for PSCI?

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.

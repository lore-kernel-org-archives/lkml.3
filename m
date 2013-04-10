Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935814Ab3DJROH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:14:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3899 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3DJROF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:14:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 10 Apr 2013 10:14:03 -0700
Message-ID: <51659DDA.8090108@nvidia.com>
Date: Wed, 10 Apr 2013 13:14:02 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [Patch V4 2/2] mfd: tps65090: Add resources for charger
References: <1363897842-19835-1-git-send-email-rklein@nvidia.com> <1363897842-19835-2-git-send-email-rklein@nvidia.com> <20130408160138.GA24058@zurbaran>
In-Reply-To: <20130408160138.GA24058@zurbaran>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/8/2013 12:01 PM, Samuel Ortiz wrote:
> Hi Rhyland,
> 
> On Thu, Mar 21, 2013 at 04:30:42PM -0400, Rhyland Klein wrote:
>> Add irq resources to pass to the charger mfd sub dev so
>> the charger can listen for interrupts.
>>
>> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
>> ---
>> v4:
>>  - Added of_compatible string to resources for tps65090-charger
>> v3:
>>  - no changes since v2
>> v2:
>>  - no changes since v1
>>
>>  drivers/mfd/tps65090.c |   11 +++++++++++
>>  1 file changed, 11 insertions(+)
> Applied as well, thanks.
> 
> Cheers,
> Samuel.
> 
It looks like the merged version was not V4 but an earlier one. V4 added
in the of_compatible string for the charger subnode and I don't see that
in the version in linux-next. I guess I'll post a new patch to add that
separately.

-rhyland

-- 
nvpublic

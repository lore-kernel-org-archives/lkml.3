Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3BDDmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 22:42:32 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12555 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab3BDDmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 22:42:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 03 Feb 2013 19:42:00 -0800
Message-ID: <510F2DC3.2060803@nvidia.com>
Date: Mon, 4 Feb 2013 09:10:51 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>, "lrg@ti.com" <lrg@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] mfd/regulator: tps65090: add DT support and suspend/resume
 cleanups
References: <1356686981-4152-1-git-send-email-ldewangan@nvidia.com> <20130203141931.GA8476@sortiz-mobl> <20130203223304.GB24304@sortiz-mobl>
In-Reply-To: <20130203223304.GB24304@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2013 04:03 AM, Samuel Ortiz wrote:
> Hi Laxman,
>
> On Sun, Feb 03, 2013 at 03:19:31PM +0100, Samuel Ortiz wrote:
>> Hi Laxman,
>>
>> On Fri, Dec 28, 2012 at 02:59:37PM +0530, Laxman Dewangan wrote:
>>> The patch series add DT support on TPS65090 device.
>>>
>>> Also remove the suspend/resume implementation as it duplicates with
>>> irq_suspend/irq_resume().
>>>
>>> Laxman Dewangan (4):
>>>    mfd: tps65090: add DT support for tps65090
>>>    regulator: tps65090: add DT support
>>>    mfd: tps65090: Pass irq domain when adding mfd sub devices
>>>    mfd: tps65090: remove suspend/resume callbacks
>>>
>>>   .../devicetree/bindings/regulator/tps65090.txt     |  121 ++++++++++++++++++++
>>>   drivers/mfd/tps65090.c                             |   77 ++++++++----
>>>   drivers/regulator/tps65090-regulator.c             |   96 +++++++++++++++-
>>>   include/linux/mfd/tps65090.h                       |    1 +
>>>   4 files changed, 266 insertions(+), 29 deletions(-)
>>>   create mode 100644 Documentation/devicetree/bindings/regulator/tps65090.txt
>> All 4 patches applied to my for-next branch, thanks.
> Sorry for the confusion: I took v2 of your patchset, skipping the regulator
> patch who will go through Mark's tree.

Thank you very much. The regulator patch is already applied in Mark's tree.

Thanks,
Laxman

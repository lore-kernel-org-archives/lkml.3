Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3IXW6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 18:58:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43409 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3IXW6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 18:58:45 -0400
Message-ID: <52421920.8010403@wwwdotorg.org>
Date: Tue, 24 Sep 2013 16:58:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
CC: lee.jones@linaro.org, sameo@linux.intel.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, rob@landley.net, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] mfd: arizona: Add device tree helper functions
References: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <5240B464.2010903@wwwdotorg.org> <20130924094937.GN3635@opensource.wolfsonmicro.com>
In-Reply-To: <20130924094937.GN3635@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 03:49 AM, Charles Keepax wrote:
> On Mon, Sep 23, 2013 at 03:36:36PM -0600, Stephen Warren wrote:
>> On 09/23/2013 12:30 PM, Charles Keepax wrote:
>>> -  - AVDD1-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,
>>> +  - AVDD-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,
>>
>> That looks like an incompatible change to the DT ABI.
> 
> The supply name in the driver is AVDD as is the name for the pin
> on the datasheet, if you specify it as AVDD1 in device tree the
> current driver will not load.
> 
> This appears to have been a copy and paste error from the wm8994
> which has 2 AVDD supplies and I believe these docs were based
> on. I would prefer to update the documentation to match what the
> driver already expects rather than the other way around.

OK, if there's no driver anywhere that can possibly work with the
binding as written, it's likely fine to change the binding.


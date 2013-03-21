Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab3CUKSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:18:52 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:47652 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3CUKSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:18:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130321094609.GM10326@intel.com>
References: <0a0ef15d47393fe9d24a395c38068b871f913776.1363337257.git.viresh.kumar@linaro.org>
	<20130321094609.GM10326@intel.com>
Date: Thu, 21 Mar 2013 15:48:50 +0530
Message-ID: <CAKohpokeZ7Udc2K_vccC1uPL=QAhpJ-vuoyFKRs84ndpDbVfqg@mail.gmail.com>
Subject: Re: [PATCH] DMA: OF: Check properties value before running
 be32_to_cpup() on it
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linaro-kernel@lists.linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 March 2013 15:16, Vinod Koul <vinod.koul@intel.com> wrote:
> On Fri, Mar 15, 2013 at 02:18:20PM +0530, Viresh Kumar wrote:
>> In of_dma_controller_register() routine we are calling of_get_property() as an
>> parameter to be32_to_cpup(). In case the property doesn't exist we will get a
>> crash.
>>
>> This patch changes this code to check if we got a valid property first and then
>> runs be32_to_cpup() on it.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>
>> My mails are broken, i have pushed this patch here:
> I noticed you used git send-email. Usually it will send patch properly
> independent of whatever MUA you use.

Probably not!! Its the famous (Infamous) Microsoft exchange server working in
background and it breaks mails without treating mails coming from git send-email
specially :)

> So I have the patch and its applied now :)

I have seen this kind of discrimination on breaking patches based on the size of
patch. If its very small (like this one), you may get a unbroken patch
but if the size
is a bit large then nobody can save you :)

--
viresh

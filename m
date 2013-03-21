Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab3CULZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:25:53 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:58175 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab3CULZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:25:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130321103845.GR10326@intel.com>
References: <0a0ef15d47393fe9d24a395c38068b871f913776.1363337257.git.viresh.kumar@linaro.org>
	<20130321094609.GM10326@intel.com>
	<CAKohpokeZ7Udc2K_vccC1uPL=QAhpJ-vuoyFKRs84ndpDbVfqg@mail.gmail.com>
	<20130321103845.GR10326@intel.com>
Date: Thu, 21 Mar 2013 16:55:49 +0530
Message-ID: <CAP245DU68ncXrCTkkO58o6ocmNk8OuiNWH4ZqVr5dOCf3AsMJA@mail.gmail.com>
Subject: Re: [PATCH] DMA: OF: Check properties value before running
 be32_to_cpup() on it
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Lists LAKML <linux-arm-kernel@lists.infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 4:08 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Thu, Mar 21, 2013 at 03:48:50PM +0530, Viresh Kumar wrote:
>> On 21 March 2013 15:16, Vinod Koul <vinod.koul@intel.com> wrote:
>> > On Fri, Mar 15, 2013 at 02:18:20PM +0530, Viresh Kumar wrote:
>> >> In of_dma_controller_register() routine we are calling of_get_property() as an
>> >> parameter to be32_to_cpup(). In case the property doesn't exist we will get a
>> >> crash.
>> >>
>> >> This patch changes this code to check if we got a valid property first and then
>> >> runs be32_to_cpup() on it.
>> >>
>> >> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>> >> ---
>> >>
>> >> My mails are broken, i have pushed this patch here:
>> > I noticed you used git send-email. Usually it will send patch properly
>> > independent of whatever MUA you use.
>>
>> Probably not!! Its the famous (Infamous) Microsoft exchange server working in
>> background and it breaks mails without treating mails coming from git send-email
>> specially :)
> I have seen usually receiving patches is a problem, not sending. at least at my
> work place till now my sent patches have not been broken but what I receive has
> thus forcing me to use non exchange accounts for receiving email but somehow situation
> is better for receiving too :)
> --
> ~Vinod
>>
>> > So I have the patch and its applied now :)
>>
>> I have seen this kind of discrimination on breaking patches based on the size of
>> patch. If its very small (like this one), you may get a unbroken patch
>> but if the size
>> is a bit large then nobody can save you :)

I've seen the Exchange bug in both forms[1]  - munging incoming
patches as well as outgoing ones. It almost feels like the Exchange
team's benevolent ploy to get companies to migrate away from Exchange
so they can end-of-life those servers and stop developing Exchange
further for the general betterment of humankind.[2]

[1] Since as far back as 8 years ago!
[2] That or they get bonuses based on how much they disrupt open
source communities. ;-)

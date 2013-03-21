Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab3CULDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:03:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:61366 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab3CULDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:03:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="282677129"
Date: Thu, 21 Mar 2013 16:08:45 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] DMA: OF: Check properties value before running
 be32_to_cpup() on it
Message-ID: <20130321103845.GR10326@intel.com>
References: <0a0ef15d47393fe9d24a395c38068b871f913776.1363337257.git.viresh.kumar@linaro.org>
 <20130321094609.GM10326@intel.com>
 <CAKohpokeZ7Udc2K_vccC1uPL=QAhpJ-vuoyFKRs84ndpDbVfqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpokeZ7Udc2K_vccC1uPL=QAhpJ-vuoyFKRs84ndpDbVfqg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 03:48:50PM +0530, Viresh Kumar wrote:
> On 21 March 2013 15:16, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Fri, Mar 15, 2013 at 02:18:20PM +0530, Viresh Kumar wrote:
> >> In of_dma_controller_register() routine we are calling of_get_property() as an
> >> parameter to be32_to_cpup(). In case the property doesn't exist we will get a
> >> crash.
> >>
> >> This patch changes this code to check if we got a valid property first and then
> >> runs be32_to_cpup() on it.
> >>
> >> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> >> ---
> >>
> >> My mails are broken, i have pushed this patch here:
> > I noticed you used git send-email. Usually it will send patch properly
> > independent of whatever MUA you use.
> 
> Probably not!! Its the famous (Infamous) Microsoft exchange server working in
> background and it breaks mails without treating mails coming from git send-email
> specially :)
I have seen usually receiving patches is a problem, not sending. at least at my
work place till now my sent patches have not been broken but what I receive has
thus forcing me to use non exchange accounts for receiving email but somehow situation
is better for receiving too :)
--
~Vinod
> 
> > So I have the patch and its applied now :)
> 
> I have seen this kind of discrimination on breaking patches based on the size of
> patch. If its very small (like this one), you may get a unbroken patch
> but if the size
> is a bit large then nobody can save you :)

> 
> --
> viresh

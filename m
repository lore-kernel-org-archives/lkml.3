Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750822Ab3HSEoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 00:44:18 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:37677 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3HSEoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 00:44:16 -0400
Message-ID: <5211A273.1080903@linux.vnet.ibm.com>
Date: Mon, 19 Aug 2013 10:13:31 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-pm@vger.kernel.org, daniel.lezcano@linaro.org, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, dongsheng.wang@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V2 5/6] cpuidle/powerpc: Backend-powerpc idle driver for
 powernv and pseries.
References: <20130731025840.19448.24468.stgit@deepthi> <20130731025934.19448.16658.stgit@deepthi> <1375830520.5600.23.camel@snotra.buserror.net> <1375831851.12557.74.camel@pasglop> <1375832471.5600.41.camel@snotra.buserror.net>
In-Reply-To: <1375832471.5600.41.camel@snotra.buserror.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081904-4790-0000-0000-000009DB8AFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 05:11 AM, Scott Wood wrote:
> On Wed, 2013-08-07 at 09:30 +1000, Benjamin Herrenschmidt wrote:
>> On Tue, 2013-08-06 at 18:08 -0500, Scott Wood wrote:
>>> Here's another example.  get_lppaca() will only build on book3s -- and
>>> yet we get requests for e500 code to use this file.
>>
>> Indeed, Besides there is already accessors afaik for lppaca that compile
>> to nothing on E (and if not they would be trivial to add).
> 
> I don't see such an accessor, but if there were, what would happen when
> the caller goes on to dereference that nothing?
> 
> There is an accessor for shared_proc specifically (in the spinlock code)
> -- not that it would be much help on booke to just compile away that
> check and always select one of the pseries state tables over the other.
> 
> -Scott

Thanks a lot Scott and Ben for the review.
I have addressed the issues in V3 of this patch series which I have just
posted out.

Regards,
Deepthi


> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
> 


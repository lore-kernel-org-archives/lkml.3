Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967980Ab3HIQMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:12:40 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:47252 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522Ab3HIQMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:12:39 -0400
Message-ID: <520514EE.1060708@calxeda.com>
Date: Fri, 09 Aug 2013 11:12:30 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>,
        "sergei.shtylyov@cogentembedded.com" 
	<sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v3 3/5] devicetree: create a separate binding description
 for sata_highbank
References: <1375890758-30265-1-git-send-email-mark.langsdorf@calxeda.com> <1375890758-30265-3-git-send-email-mark.langsdorf@calxeda.com> <20130809161015.GQ20515@mtj.dyndns.org>
In-Reply-To: <20130809161015.GQ20515@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 11:10 AM, Tejun Heo wrote:
> On Wed, Aug 07, 2013 at 10:52:36AM -0500, Mark Langsdorf wrote:
>> The Calxeda sata_highbank driver has been adding its descriptions to the
>> ahci driver. Separate them properly.
>>
>> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
>> Acked-by: Rob Herring <rob.herring@calxeda.com>
>
> Will wait for the update.  I suppose this doesn't need to go in to
> for-3.11-fixes?  I'd really appreciate what impact each patch has.

I'll update the description when I resubmit it to give you more detail 
on the impact.

Thanks for applying the others.

--Mark Langsdorf
Calxeda, Inc.


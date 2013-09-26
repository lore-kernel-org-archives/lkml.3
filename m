Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3IZU6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 16:58:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40797 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3IZU6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 16:58:10 -0400
Date: Thu, 26 Sep 2013 13:58:08 -0700
From: David Brown <davidb@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCHv4 2/3] ARM: msm: Add support for APQ8074 Dragonboard
Message-ID: <20130926205808.GA3146@codeaurora.org>
References: <1379992406-3541-1-git-send-email-rvaswani@codeaurora.org>
 <1379992406-3541-2-git-send-email-rvaswani@codeaurora.org>
 <4E7868D6-56CB-4AF8-8EBF-069966899C23@codeaurora.org>
 <5243652F.7090408@codeaurora.org>
 <B0F416B8-042A-49F1-81E9-B217F02AAD1E@codeaurora.org>
 <52447779.3010908@codeaurora.org>
 <52448852.9050608@codeaurora.org>
 <50877C70-6066-4E87-9DEA-9F29D098525B@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <50877C70-6066-4E87-9DEA-9F29D098525B@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 02:33:53PM -0500, Kumar Gala wrote:

>> "ePAPR 1.1 section 2.2.1.1 "Node Name Requirements" specifies that any
>> node that has a reg property must include a unit address in its name
>> with value matching the first entry in its reg property. Conversely, if
>> a node does not have a reg property, the node name must not include a
>> unit address."
>>
>> The soc node we have does not have a reg property ?
>
>Not 100% sure what people will decide on this.  There are a number of
>examples on the PPC side (arch/powerpc/boot/dts) that are soc@ADDR,
>but they don't typically have "reg" properties at the soc level.
>
>Let's go ahead w/o the unit address (as you have it) for now.

What is the address even supposed to mean?  Are we expecting multiple
'soc' nodes?

David

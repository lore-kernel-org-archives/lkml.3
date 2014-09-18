Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbaIRQ6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:58:34 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:34084 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752053AbaIRQ6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:58:32 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19P3H5Buq0o5rU98aaFnXwX
Date: Thu, 18 Sep 2014 09:58:18 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: balbi@ti.com, devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: DRA7: Add PMU nodes
Message-ID: <20140918165817.GI14505@atomide.com>
References: <1408456440-30171-1-git-send-email-nm@ti.com>
 <540719FC.5070803@ti.com>
 <20140917142503.GA11856@kahuna>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917142503.GA11856@kahuna>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140917 07:26]:
> On 08:39-20140903, Nishanth Menon wrote:
> > On 08/19/2014 08:54 AM, Nishanth Menon wrote:
> > > From: Lucas Weaver <l-weaver@ti.com>
> > > 
> > > DRA74x and DRA72x family of processors vary slightly in the number
> > > of CPUs. So, add different instances of PMU for each of these processor
> > > groups. Further, since the interrupts bypass crossbar and are directly
> > > connected to GIC, mark the dts nodes with relevant information.
> > > 
> > > Tested with perf utility.
> > > 
> > > Reviewed-by: Felipe Balbi <balbi@ti.com>
> > > Signed-off-by: Lucas Weaver <l-weaver@ti.com>
> > > Signed-off-by: Nishanth Menon <nm@ti.com>
> > > ---
> > Hi,
> > Gentle ping..
> 
> Tony,
> I dont see this patch in omap-for-v3.18/dt
> 
> Is there anyway you might consider pulling this for 3.18?
> 
> Patchworks link:
> https://patchwork.kernel.org/patch/4743121/

Thanks applying into omap-for-v3.18/dt.

Tony

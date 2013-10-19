Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3JSBtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 21:49:25 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50979 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab3JSBtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 21:49:22 -0400
Date: Fri, 18 Oct 2013 18:49:19 -0700
From: Michael Bohan <mbohan@codeaurora.org>
To: Rob Herring <robherring2@gmail.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Guenter Roeck <linux@roeck-us.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, ralf@linux-mips.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        david.daney@cavium.com, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] of/lib: Export fdt routines to modules
Message-ID: <20131019014919.GB30244@codeaurora.org>
References: <20131017002731.GA22830@codeaurora.org>
 <525F6D83.1050808@roeck-us.net>
 <20131017235132.GA6241@codeaurora.org>
 <52608457.5040609@roeck-us.net>
 <20131018025405.GA3722@codeaurora.org>
 <33103C16-6472-4AAE-ADB8-50807CC96C85@antoniou-consulting.com>
 <52615A64.9040803@gmail.com>
 <52616228.80002@caviumnetworks.com>
 <20131018193229.GA30141@codeaurora.org>
 <5261A609.1020605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5261A609.1020605@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 04:20:09PM -0500, Rob Herring wrote:
> On 10/18/2013 02:32 PM, Michael Bohan wrote:
> > My preference is probably straight libfdt calls, but if others
> > think that unpacking is a better solution, I'm able to go that
> > route as well. My only concern there is that we provide a means
> > to detect invalid dtb image (ex. handle error codes) and also
> > free the device_node allocations once the device is released.
> 
> I think we need to understand what you are putting in the DT first.

That's understandable. Please see my response to Mark.

> Given there are other desired uses like overlays which need to add the
> necessary loading and unflattening support, a common solution is likely
> more desirable.

But by convention, would overlays allow for 'application
specific' data, or are they expected to meet the more rigid
requirements of a real Device Tree?

Thanks,
Mike

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab3J2FGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 01:06:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53525 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab3J2FGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 01:06:47 -0400
Date: Mon, 28 Oct 2013 22:06:45 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/6] edac: Document Krait L1/L2 EDAC driver binding
Message-ID: <20131029050645.GC21983@codeaurora.org>
References: <1383006690-6754-1-git-send-email-sboyd@codeaurora.org>
 <1383006690-6754-5-git-send-email-sboyd@codeaurora.org>
 <20131029013454.GJ4763@kartoffel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029013454.GJ4763@kartoffel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28, Mark Rutland wrote:
> On Tue, Oct 29, 2013 at 12:31:28AM +0000, Stephen Boyd wrote:
> > +
> > +Optional properties:
> > +- interrupt-names: Should contain the interrupt names "l1_irq" and
> > +  "l2_irq"
> 
> As with my comment on the parsing code, I'd prefer that if interrupt-names was
> present it defined the order of interrupts. Otherwise it's redundant and of no
> value.
> 
> Otherwise, the binding looks fine to me:
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>

How about I just drop the interrupt-names property? It isn't
adding much and is a holdover from the vendor kernel.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

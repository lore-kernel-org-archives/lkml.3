Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab3KHQw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:52:58 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:43202 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab3KHQw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:52:57 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+3bpskFsIZIAYHFhe1yuWVMGWL7eQKNNk=
Date: Fri, 8 Nov 2013 11:52:55 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Subject: Re: common location for devicetree files
Message-ID: <20131108165255.GA32668@titan.lakedaemon.net>
References: <1438803E-C904-428B-B042-891978BC15DF@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1438803E-C904-428B-B042-891978BC15DF@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 05:21:58PM -0600, Kumar Gala wrote:
> As we start having more sharing of device trees between architectures
> (arm & arm64, arm & powerpc, guessing maybe mips & arm) we need dts to
> live in location that 
> 
> I was wondering what people felt about doing:
> 
> 	arch/dts/<VENDOR>/
> 
> as a common location that could be shared.  I'm up for other
> suggestions.

What do we really need to do before the move?  Should all arch dts files
be able to #include from any arch?  What's the minimum churn needed to
accomplish that?  Maybe just move the needed bits to arch/dts/include/ ?

I'm not real keen on separating by vendor.  For example, us mvebu folks
would probably miss useful/duplicated effort in another vendor's
subdirectory.  Which was the whole reason for moving driver code out of
machine directories to begin with.

thx,

Jason.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3AQWbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:31:52 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:35529 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750814Ab3AQWbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:31:51 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18v1xGGp/o3iLi9fq361fbk
Date: Thu, 17 Jan 2013 14:31:39 -0800
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Felipe Balbi <balbi@ti.com>, Roger Quadros <rogerq@ti.com>,
        sameo@linux.intel.com, kishon@ti.com, sshtylyov@mvista.com,
        bjorn@mork.no, linux@arm.linux.org.uk, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rajendra Nayak <rnayak@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Mike Turquette <mturquette@linaro.com>
Subject: Re: [PATCH v7 19/22] ARM: OMAP3: clock data: get rid of unused USB
 host clock aliases and dummies
Message-ID: <20130117223138.GN14149@atomide.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com>
 <1358422231-24736-20-git-send-email-rogerq@ti.com>
 <20130117170321.GJ14149@atomide.com>
 <alpine.DEB.2.00.1301171854280.14118@utopia.booyaka.com>
 <20130117210034.GA27671@arwen.pp.htv.fi>
 <alpine.DEB.2.00.1301172228140.14118@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1301172228140.14118@utopia.booyaka.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [130117 14:33]:
> On Thu, 17 Jan 2013, Felipe Balbi wrote:
> 
> > do you mean v3.9 ?
> 
> It sounds like the other patches need to be merged first before these 
> cleanups can be merged.  So rather than adding a merge order dependency 
> during 3.9, it seems best to queue the non-essential clock cleanup side 
> for 3.10.

How about let's do it in a late cleanup branch towards the end of the
v3.9 merge window?

Regards,

Tony

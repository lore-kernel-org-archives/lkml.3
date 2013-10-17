Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab3JQRdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:33:14 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52762 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758205Ab3JQRdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:33:13 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/OUeG1EPAx7CfYmImy0/nV
Date: Thu, 17 Oct 2013 10:33:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [RFC 9/9] of/irq: create interrupts-extended property
Message-ID: <20131017173310.GC15154@atomide.com>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
 <1381869563-16083-10-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381869563-16083-10-git-send-email-grant.likely@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely <grant.likely@linaro.org> [131015 13:43]:
> The standard interrupts property in device tree can only handle
> interrupts coming from a single interrupt parent. If a device is wired
> to multiple interrupt controllers, then it needs to be attached to a
> node with an interrupt-map property to demux the interrupt specifiers
> which is confusing. It would be a lot easier if there was a form of the
> interrupts property that allows for a separate interrupt phandle for
> each interrupt specifier.
> 
> This patch does exactly that by creating a new interrupts-extended
> property which reuses the phandle+arguments pattern used by GPIOs and
> other core bindings.
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>

Works for me and solves the issue for devices with interrupts
from multiple interrupt controllers:

Acked-by: Tony Lindgren <tony@atomide.com>


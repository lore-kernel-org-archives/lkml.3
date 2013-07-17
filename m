Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab3GQPkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:40:45 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56523 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756080Ab3GQPkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:40:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Vq0QPFaH0FZ36b3LbwQ2k
Date: Wed, 17 Jul 2013 08:40:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/3] pinctrl: rollback check for !dev->pins in
 pinctrl_pm_select*() APIs
Message-ID: <20130717154038.GK7656@atomide.com>
References: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com>
 <1374061312-25469-2-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374061312-25469-2-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grygorii Strashko <grygorii.strashko@ti.com> [130717 04:49]:
> The pinctrl support in Device core assumed to be optional - so, It's
> valid case, when there are no definition for default device's pinctrl
> states in DT at all ("default", "active", "idle", "sleep").
> And in this case dev->pins == NULL and pinctrl_pm_select*() API
> should return 0 always.
> 
> Now the checks for !dev->pins have been removed from
> pinctrl_pm_select*() API mistakenly by the patch
> pinctrl: Remove duplicate code in pinctrl_pm_select_state functions
> http://www.spinics.net/lists/arm-kernel/msg258829.html
> 
> Hence, rollback these checks in in pinctrl_pm_select*() APIs.

Thanks, it's best that I fold this fix into my patch as it has not
been committed yet.

Regards,

Tony

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab3FYHlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:41:08 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:17718 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3FYHlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:41:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19rG/aSkAFcLq/JCTIyAFd0
Date: Tue, 25 Jun 2013 00:41:03 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: rip out the direct pinconf API
Message-ID: <20130625074102.GG5523@atomide.com>
References: <1372079700-16580-1-git-send-email-linus.walleij@stericsson.com>
 <51C86524.8020708@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C86524.8020708@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [130624 08:32]:
> On 06/24/2013 07:15 AM, Linus Walleij wrote:
> > From: Linus Walleij <linus.walleij@linaro.org>
> > 
> > From the inception ot the pin config API there has been the
> > possibility to get a handle at a pin directly and configure
> > its electrical characteristics. For this reason we had:
> > 
> > int pin_config_get(const char *dev_name, const char *name,
> >                unsigned long *config);
> > int pin_config_set(const char *dev_name, const char *name,
> >                unsigned long config);
> > int pin_config_group_get(const char *dev_name,
> >                const char *pin_group,
> >                unsigned long *config);
> > int pin_config_group_set(const char *dev_name,
> >                const char *pin_group,
> >                unsigned long config);
> > 
> > After the intruction of the pin control states that will
> > control pins associated with devices, and its subsequent
> > introduction to the device core, as well as the
> > introduction of pin control hogs that can set up states on
> > boot and optionally also at sleep, this direct pin control
> > API is a thing of the past.
> > 
> > As could be expected, it has zero in-kernel users.
> > Let's delete this API and make our world simpler.
> 
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Tony Lindgren <tony@atomide.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab3FEWBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:01:52 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55004 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab3FEWBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 18:01:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/o4atswQe2O2D0F6pPDd40
Date: Wed, 5 Jun 2013 15:01:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Manjunathappa, Prakash" <prakash.pm@ti.com>
Cc: linus.walleij@linaro.org, nsekhar@ti.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux@arm.linux.org.uk, rob@landley.net,
        prabhakar.csengg@gmail.com, peter.ujfalusi@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH 1/3] pinctrl: pinctrl-single: enhance to configure
 multiple pins of different modules
Message-ID: <20130605220138.GE3331@atomide.com>
References: <1369145282-14419-1-git-send-email-prakash.pm@ti.com>
 <1369145282-14419-3-git-send-email-prakash.pm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369145282-14419-3-git-send-email-prakash.pm@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Manjunathappa, Prakash <prakash.pm@ti.com> [130521 07:13]:
> Add support to configure multiple pins in each register, existing
> implementation added by [1] does not support full fledge multiple pin
> configuration in single register, reports a pin clash when different
> modules configure different bits of same register. The issue reported
> and discussed here
> http://www.spinics.net/lists/arm-kernel/msg235213.html
> 
> With pinctrl-single,bits-per-mux property specified, use function-mask
> property to find out number pins to configure. Allocate and register
> pin control functions based sub mask.

Thanks for fixing this! Looks good to me, and things keep
working for me just fine with these applied:

Acked-by: Tony Lindgren <tony@atomide.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611Ab3CSShk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:37:40 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:42413 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933217Ab3CSShj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:37:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/QMgEZXysqCV1vQZYkHugu
Date: Tue, 19 Mar 2013 11:37:36 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2 00/23] ARM: OMAP2+: Adapt to ehci-omap changes for
 3.10
Message-ID: <20130319183736.GG16413@atomide.com>
References: <1363360604-21368-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363360604-21368-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

* Roger Quadros <rogerq@ti.com> [130315 08:20]:
> Hi Tony,
> 
> These patches provide the SoC side code required to support
> the changes in the OMAP USB Host drivers done in [1], [2] & [3].
> 
> Device tree support is added for Beagleboard and Panda.
> 
> NOTE: The first patch needs to be shared between the
> OMAP tree and Felipe's USB tree.

Do you want to put the platform_data header changes alone
into some immutable branch or want me to do it?

Regards,

Tony

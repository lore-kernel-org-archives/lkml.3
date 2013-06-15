Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3FOLNO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 07:13:14 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:52583 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab3FOLNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 07:13:12 -0400
Date: Sat, 15 Jun 2013 13:12:20 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Joe Perches <joe@perches.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v3] ethernet/arc/arc_emac - Add new driver
Message-ID: <20130615111220.GB14242@electric-eye.fr.zoreil.com>
References: <1371134239-4531-1-git-send-email-abrodkin@synopsys.com>
 <20130613221946.GA16632@electric-eye.fr.zoreil.com>
 <4881796E12491D4BB15146FE0209CE643F5E3A07@DE02WEMBXB.internal.synopsys.com>
 <20130614192704.GA4857@electric-eye.fr.zoreil.com>
 <4881796E12491D4BB15146FE0209CE643F5E5730@DE02WEMBXB.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4881796E12491D4BB15146FE0209CE643F5E5730@DE02WEMBXB.internal.synopsys.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Brodkin <Alexey.Brodkin@synopsys.com> :
[...]
> If my comment doesn't make sense to you or I misunderstood your message 
> could you please add more clarifications for your idea?

Sorry, I temporarily forgot it was the descriptor ring itself. :o/

It would make sense to qualify the descriptor members as __{le/be}32 then
use them with proper cpu_to_{le/be} wrappers _and_ mapping addresses
instead of direct skb->data assignment.

-- 
Ueimor

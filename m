Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbaCETrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:47:53 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:11786 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbaCETrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:47:51 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+nfawIrIZke6CS9/udZ+uA
Date: Wed, 5 Mar 2014 11:47:46 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/4] ARM: dts: OMAP3630+: Add ABB device nodes
Message-ID: <20140305194745.GE7599@atomide.com>
References: <1391039177-25284-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391039177-25284-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140129 15:48]:
> Now that clock nodes have been merged to master,
> refresh of the series meant for all TI platforms using ABB.
> Originally posted [1], I will restart with v1.

Thanks applying all except for the crossbar ones into
omap-for-v3.15/dt.

Please resend the last three patches once the dependencies
are merged to mainline kernel as otherwise the interrupt
nubers are all wrong without the crossbar driver related
code.

Regards,

Tony

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaFMNPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:15:47 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:43519 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750863AbaFMNPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:15:45 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+xRSPSo1Qlsh6sTyuamODTaNcGJcbx+HE=
X-DKIM: OpenDKIM Filter v2.0.1 titan 86E8158EC25
Date: Fri, 13 Jun 2014 09:15:26 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sricharan R <r.sricharan@ti.com>
Cc: Joe Perches <joe@perches.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com,
        santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk, tglx@linutronix.de
Subject: Re: [PATCH V2 08/19] irqchip: crossbar: fix checkpatch warning
Message-ID: <20140613131526.GH8664@titan.lakedaemon.net>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
 <1402574007-13987-9-git-send-email-r.sricharan@ti.com>
 <20140612131042.GU8664@titan.lakedaemon.net>
 <5399AC9C.4080602@ti.com>
 <1402582711.9947.17.camel@joe-AO725>
 <20140612153226.GE8664@titan.lakedaemon.net>
 <1402589159.12385.4.camel@joe-AO725>
 <539A9A87.6020004@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539A9A87.6020004@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 12:00:31PM +0530, Sricharan R wrote:
>   Ok, if this is not qualifying as a separate patch then i will merge
>   this with other patches in the series which touch them.

A good general rule of thumb is to just run checkpatch on the patches,
not the source files.  This way, we prevent new warnings from being
introduced, and we can cleanup stuff in the immediate vicinity to code
we are already changing.

thx,

Jason.

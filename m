Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaINFrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 01:47:03 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:64695 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752294AbaINFrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 01:47:01 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/w7+F8vA+7+LWleRj8ZyWXO3il+111R/U=
X-DKIM: OpenDKIM Filter v2.0.1 titan 618F65E12CF
Date: Sun, 14 Sep 2014 01:46:48 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] irqchip: atmel-aic: add RTT irq fixup
Message-ID: <20140914054648.GJ21986@titan.lakedaemon.net>
References: <1409735271-15353-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409735271-15353-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 11:07:46AM +0200, Boris BREZILLON wrote:
> The series depends on the acceptation of the RTT DT bindings proposed here
> [1].
> 
> Best Regards,
> 
> Boris
> 
> [1]https://lkml.org/lkml/2014/9/3/145

Hmm, the bindings, unfortunately, still seem to be in flux.  Any update?

thx,

Jason.

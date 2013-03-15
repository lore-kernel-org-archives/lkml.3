Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab3COQ2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:28:45 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22894 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751502Ab3COQ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:28:44 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Xsqf+F4CkJOGXcu/G6ifn
Date: Fri, 15 Mar 2013 09:28:38 -0700
From: Tony Lindgren <tony@atomide.com>
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] ir: IR_RX51 only works on OMAP2
Message-ID: <20130315162837.GD9370@atomide.com>
References: <1363298204-8014-1-git-send-email-arnd@arndb.de>
 <1363298204-8014-7-git-send-email-arnd@arndb.de>
 <20130315063913.GC1638@itanic.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130315063913.GC1638@itanic.dhcp.inet.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Timo Kokkonen <timo.t.kokkonen@iki.fi> [130314 23:43]:
> On 03.14 2013 22:56:44, Arnd Bergmann wrote:
> > This driver can be enabled on OMAP1 at the moment, which breaks
> > allyesconfig for that platform. Let's mark it OMAP2PLUS-only
> > in Kconfig, since that is the only thing it builds on.
> > 
> 
> Acked-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>

Acked-by: Tony Lindgren <tony@atomide.com>

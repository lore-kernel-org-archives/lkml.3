Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964772Ab3HIO7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:59:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:31144 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933972Ab3HIO7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:59:45 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18sLnNCVaBLh4LpLXACkwHEn8iY4g4OElk=
Date: Fri, 9 Aug 2013 10:59:39 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci <linux-pci@vger.kernel.org>
Subject: Re: linux-next: Tree for Aug 8 (not CONFIG_PCI_MSI conflict)
Message-ID: <20130809145939.GE25111@titan.lakedaemon.net>
References: <20130808170822.82bf33d3cf5100f5e2646815@canb.auug.org.au>
 <5203F978.2050504@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5203F978.2050504@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy,

On Thu, Aug 08, 2013 at 01:03:04PM -0700, Randy Dunlap wrote:
> On 08/08/13 00:08, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20130807:
> > 
> 
> on i386 and x86_64:
> when CONFIG_PCI_MSI is not enabled:
> 
> There are many of these errors:
> include/linux/msi.h:65:6: error: expected identifier or '(' before 'void'
> include/linux/msi.h:65:6: error: expected ')' before numeric constant
> 
> because arch/x86/include/asm/pci.h defines:
> #define default_teardown_msi_irqs	NULL

Do you have an example config you used?

thx,

Jason.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaIDOwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:52:16 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:47029 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750797AbaIDOwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:52:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19vm4y+sTOskOrLOkcV4MwA
Date: Thu, 4 Sep 2014 07:52:04 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: balbi@ti.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 15/15] tty: serial: 8250: omap: add dma support
Message-ID: <20140904145203.GR11766@atomide.com>
References: <53FF84DF.7080406@linutronix.de>
 <20140828225454.GM16006@atomide.com>
 <540048B4.7010807@linutronix.de>
 <20140829161221.GO16006@atomide.com>
 <5404B149.6010400@linutronix.de>
 <54060EDA.6060204@linutronix.de>
 <20140902201536.GC11766@atomide.com>
 <540745CC.2090901@linutronix.de>
 <20140903174845.GE11766@atomide.com>
 <54086CA7.8020507@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54086CA7.8020507@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140904 06:46]:
> On 09/03/2014 07:48 PM, Tony Lindgren wrote:
> 
> I will check this upper part of this email soon…
> 
> > OK. At least it's starting to now sound that the bugs are pretty much
> > the same with 8250 and serial-omap :)
> 
> Do you see a reason for not posting the entire series again since now I
> am bug compatible in the pm-runtime part? We have -rc3 and I would like
> to get this merge the series I have now and this seems to be the only
> problem I am aware of.

Yeah makes sense to me. Thanks for ensuring the bug
compability :)

Regards,

Tony

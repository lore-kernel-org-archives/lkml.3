Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaFXMpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:45:43 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:38460 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752199AbaFXMpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:45:42 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18j7u+p5TKDcwHeEmzH6XCx9X6677DWsaI=
X-DKIM: OpenDKIM Filter v2.0.1 titan 30F33598712
Date: Tue, 24 Jun 2014 08:45:38 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com
Subject: Re: [patch 00/13] irqchip: spear_shirq: Cleanup the bitrot
Message-ID: <20140624124538.GM10202@titan.lakedaemon.net>
References: <20140619212606.431750473@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619212606.431750473@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:34:36PM -0000, Thomas Gleixner wrote:
> The driver is broken for spear320 since commit 80515a5a(ARM: SPEAr3xx:
> shirq: simplify and move the shared irq multiplexor to DT). Clearly
> never tested on spear320.
> 
> Aside of that it's an unreadable overengineered trainwreck with lots
> of obscure "functionality". 
> 
> Make it work and clean it up.

#2 - 13 applied to irqchip/core with Viresh's Ack and a dep on
irqchip/urgent for patch #1.

thx,

Jason.

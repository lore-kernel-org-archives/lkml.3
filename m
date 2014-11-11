Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaKKNpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:45:55 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22832 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaKKNpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:45:51 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ZbjweJZR1HbPB1aCJ7pZBeDWWZqZn2w0=
X-DKIM: OpenDKIM Filter v2.0.1 titan 8B386617E1A
Date: Tue, 11 Nov 2014 08:45:36 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/3] irqchip: dw-apb-ictl: IRQ_GC_MASK_CACHE_PER_TYPE
 and PM support
Message-ID: <20141111134536.GD3698@titan.lakedaemon.net>
References: <1411454100-6814-1-git-send-email-jszhang@marvell.com>
 <20141111135947.393a6d78@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111135947.393a6d78@xhacker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 01:59:47PM +0800, Jisheng Zhang wrote:
> Dear Thomas, Jason,
> 
> Is there any potential issue with this patch serials I need to resolve?

Please send a v2 with Sebastian's Acks.  Also, please update the commit
log on #1 as requested.  For #3, Please add a summary of the discussion
to its commit log.  eg: "We can used relaxed variants here because..."

thx,

Jason.

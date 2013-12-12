Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab3LLMCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:02:44 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:43806 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3LLMCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:02:42 -0500
Date: Thu, 12 Dec 2013 21:02:38 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca, tglx@linutronix.de
Subject: Re: [PATCH 00/02] irqchip: renesas-irqc: Lazy disable and
 mask-on-suspend
Message-ID: <20131212120235.GC18308@verge.net.au>
References: <20131204120537.29642.942.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204120537.29642.942.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 09:05:37PM +0900, Magnus Damm wrote:
> irqchip: renesas-irqc: Lazy disable and mask-on-suspend
> 
> [PATCH 01/02] irqchip: renesas-irqc: Use lazy disable
> [PATCH 02/02] irqchip: renesas-irqc: Enable mask on suspend
> 
> Update the IRQC driver to use lazy disable and mask on suspend. This fixes
> the Suspend-to-RAM behavior to make sure wakeup sources are left enabled
> while suspending.

Thanks, I will queue these up.

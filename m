Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3DVKrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:47:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57294 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216Ab3DVKrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:47:04 -0400
Date: Mon, 22 Apr 2013 11:46:54 +0100
From: Will Deacon <will.deacon@arm.com>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        marc.zyngier@arm.com, dave.martin@arm.com
Subject: Re: arm: ARM_VIRT_EXT is not supported by all v7 platforms, so it
 should not be enabled by default
Message-ID: <20130422104653.GA2572@mudshark.cambridge.arm.com>
References: <kks14c$e4p$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kks14c$e4p$1@ger.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 07:07:15PM +0100, Sebastian Gottschall wrote:
> introduced in kernel 3.9 CONFIG_ARM_VIRT_EXT is default for all V7 arm 
> cpu's. this is wrong and breaks smp support on BCM4708 for example.
> so keep it optional since no all v7 cpu's seem to support it. BCM4708 
> for instance is a arm cortex-a9. please merge this into one of the next 
> patches.

This was intentional, since ARM_VIRT_EXT shouldn't have any visible effect
when selected on CPUs without the virtualisation extensions.

If this is breaking SMP support, then there is a bug somewhere, so please
can elaborate on the problems which you are seeing?

Cheers,

Will

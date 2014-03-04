Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbaCDTMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:12:06 -0500
Received: from www.xora.org.uk ([80.68.91.202]:38312 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbaCDTMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:12:02 -0500
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2014 14:12:02 EST
Date: Wed, 5 Mar 2014 03:03:18 +0800
From: Graeme Gregory <graeme@xora.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add maintainers for arm64 acpi
Message-ID: <20140304190318.GE28736@xora-yoga13>
References: <1393899345-7397-1-git-send-email-graeme.gregory@linaro.org>
 <1393899345-7397-2-git-send-email-graeme.gregory@linaro.org>
 <20140304102316.GG30596@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140304102316.GG30596@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 10:23:16AM +0000, Catalin Marinas wrote:
> On Tue, Mar 04, 2014 at 02:15:45AM +0000, Graeme Gregory wrote:
> > +ACPI ARM64
> 
> That's a pretty broad statement for a single file. Is it core support,
> architected peripherals, SoC?
> 
Hi Catalin would changing the title to ACPI ARM64 Core Support be better
in your mind. I do intend for the maintainership to cover just the
plat/arm-core.c file.

Graeme

> > +M:	Hanjun Guo <hanjun.guo@linaro.org>
> > +M:	Graeme Gregory <graeme.gregory@linaro.org>
> > +S:	Supported
> > +L:	linux-acpi@vger.kernel.org
> > +F:	drivers/acpi/plat/arm-core.c
> 
> This patch should be part of the series introducing the arm-core.c file
> and it will be ACKed (or NAKed) following review. We can't really commit
> maintainers to a file which does not exist in mainline and while there is
> still feedback to be addressed. It's like a blank cheque.
> 
> -- 
> Catalin
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

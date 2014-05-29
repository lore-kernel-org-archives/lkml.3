Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbaE2IKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:10:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38836 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756330AbaE2IKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:10:05 -0400
Date: Thu, 29 May 2014 09:07:05 +0100
From: Will Deacon <will.deacon@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 5/8] arm64: Add ftrace support
Message-ID: <20140529080705.GD29812@arm.com>
References: <1394862048-28758-1-git-send-email-takahiro.akashi@linaro.org>
 <1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
 <1398851676-16389-6-git-send-email-takahiro.akashi@linaro.org>
 <20140528201955.GJ5099@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528201955.GJ5099@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 09:19:55PM +0100, Mark Brown wrote:
> On Wed, Apr 30, 2014 at 06:54:33PM +0900, AKASHI Takahiro wrote:
> 
> > +/*
> > + * arch/arm64/kernel/entry-ftrace.S
> > + *
> > + * Copyright (C) 2013 Linaro Limited
> > + * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/linkage.h>
> > +#include <asm/ftrace.h>
> > +#include <asm/insn.h>
> 
> asm/insn.h contains a bunch of C stuff which won't build without
> __ASSEMBLY__ guards unless I'm missing something (I'm working with a
> non-mainline tree so I might be).

The guards are added earlier in this series.

Will

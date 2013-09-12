Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab3ILVWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 17:22:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127Ab3ILVWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 17:22:40 -0400
Message-ID: <1379020912.14495.23.camel@deneb.redhat.com>
Subject: Re: [PATCH] Kconfig cleanup (PARPORT_PC dependencies)
From: Mark Salter <msalter@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, rth@twiddle.net,
        vgupta@synopsys.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
        jejb@parisc-linux.org, benh@kernel.crashing.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date: Thu, 12 Sep 2013 17:21:52 -0400
In-Reply-To: <20130912203204.GA26170@merkur.ravnborg.org>
References: <1379012038-31764-1-git-send-email-msalter@redhat.com>
	 <20130912203204.GA26170@merkur.ravnborg.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 22:32 +0200, Sam Ravnborg wrote:
> It is much nicer if you provide a config symbol only once.
> And then let the architectures who want it select this symbol.
> 
> This is the pattern we use for similar things in many places today,
> so it is best to follow that pattern.

Okay, I'm ahead of you on that. I actually had two versions of the
patch. The other uses select. If that is the preferred way these
days, I'll go with it for V2 of the patch.



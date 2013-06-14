Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab3FNGg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 02:36:26 -0400
Received: from 1wt.eu ([62.212.114.60]:36332 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab3FNGgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 02:36:25 -0400
Date: Fri, 14 Jun 2013 08:36:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc: Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Linux 2.6.32.61 - x86/ptrace/gcc 4.7 build error
Message-ID: <20130614063621.GB880@1wt.eu>
References: <20130610101557.GA3235@1wt.eu> <alpine.DEB.2.10.1306101708360.1713@aurora64.sdinet.de> <20130613175330.GC27760@1wt.eu> <1371190377@msgid.manchmal.in-ulm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371190377@msgid.manchmal.in-ulm.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Fri, Jun 14, 2013 at 08:23:18AM +0200, Christoph Biedl wrote:
> Willy Tarreau wrote...
> 
> > I'm attaching the two patches here to be appled on top of 2.6.32.61, I would
> > like it if you could try in your environment to confirm that they correctly
> > fix the issue.
> 
> Confirmation: Kernel builds and runs for both Debian squeeze and
> wheezy (gcc 4.4 and gcc 4.7) on i386.
> 
> There are still other issues that need investigation but they might be
> older and/or related to changes on my end. virtio-net doesn't seem to
> work at all (but does so in the Debian squeeze 2.6.32 kernel), and the
> virtualbox guest module (4.1.18) fails to load (known issue on i386 if
> build using gcc 4.7, but know this also happens with gcc 4.4).

Thanks for your report. Do you know if the issues you get are regressions
from 2.6.32.60 or just compared to the Debian kernel ?

Willy


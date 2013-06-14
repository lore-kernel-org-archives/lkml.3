Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab3FNGba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 02:31:30 -0400
Received: from manchmal.in-ulm.de ([217.10.9.201]:55689 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3FNGb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 02:31:29 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jun 2013 02:31:29 EDT
Date: Fri, 14 Jun 2013 08:23:18 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Linux 2.6.32.61 - x86/ptrace/gcc 4.7 build error
Message-ID: <1371190377@msgid.manchmal.in-ulm.de>
References: <20130610101557.GA3235@1wt.eu>
 <alpine.DEB.2.10.1306101708360.1713@aurora64.sdinet.de>
 <20130613175330.GC27760@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613175330.GC27760@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote...

> I'm attaching the two patches here to be appled on top of 2.6.32.61, I would
> like it if you could try in your environment to confirm that they correctly
> fix the issue.

Confirmation: Kernel builds and runs for both Debian squeeze and
wheezy (gcc 4.4 and gcc 4.7) on i386.

There are still other issues that need investigation but they might be
older and/or related to changes on my end. virtio-net doesn't seem to
work at all (but does so in the Debian squeeze 2.6.32 kernel), and the
virtualbox guest module (4.1.18) fails to load (known issue on i386 if
build using gcc 4.7, but know this also happens with gcc 4.4).

Unfortunately my time ressources are very limited at the moment, and
there's also something in 3.4.49 which has higher priority. Stay
tuned.

    Christoph

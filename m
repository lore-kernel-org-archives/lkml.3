Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbbAXRUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 12:20:08 -0500
Received: from down.free-electrons.com ([37.187.137.238]:56475 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753261AbbAXRUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 12:20:06 -0500
Date: Sat, 24 Jan 2015 18:20:00 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] ARM: at91: fix irq_pm_install_action WARNING
Message-ID: <20150124182000.59a4a96b@bbrezillon>
In-Reply-To: <alpine.DEB.2.11.1501241735530.5526@nanos>
References: <1422032971-14139-1-git-send-email-boris.brezillon@free-electrons.com>
	<alpine.DEB.2.11.1501241735530.5526@nanos>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Sat, 24 Jan 2015 17:37:48 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Fri, 23 Jan 2015, Boris Brezillon wrote:
> >  - change the compatible string to clearly show that this chip is purely
> >    virtual
> 
> So we probably want to do : s/dumb/virt/ for both DT and code to make
> it clear from the names as well.

I thought the dumb word was denoting the simplicity (stupidity ?) of
the irq demultiplexer, but indeed, I don't see how a virtual irq demuxer
could have enough information to do a better job (if there's an
interrupt cause register, then it's not a virtual/software demuxer
anymore).
So replacing dumb by virt or virtual makes sense here.


Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

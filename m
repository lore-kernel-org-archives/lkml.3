Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab3AMNui (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 08:50:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:2785 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813Ab3AMNuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 08:50:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,461,1355126400"; 
   d="scan'208";a="245975433"
Date: Sun, 13 Jan 2013 05:25:44 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, jaswinder.singh@linaro.org,
        will.deacon@arm.com, linux@arm.linux.org.uk, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, djbw@fb.com,
        grant.likely@secretlab.ca, rubini@gnudd.com, wim@iguana.be,
        cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: Re: [PATCH v4 2/7] pl080.h: moved from arm/include/asm/hardware to
 include/linux/amba/
Message-ID: <20130113132544.GZ19691@intel.com>
References: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com>
 <1355146956-6009-3-git-send-email-ciminaghi@gnudd.com>
 <CACRpkdbF6S6nOQFwv+tmS4LXhnnwkQxzmGYmH3Xn6TM4E34r8g@mail.gmail.com>
 <20121210222516.GA31546@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210222516.GA31546@mail.gnudd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 11:25:17PM +0100, Davide Ciminaghi wrote:
> On Mon, Dec 10, 2012 at 10:44:09PM +0100, Linus Walleij wrote:
> > On Mon, Dec 10, 2012 at 2:42 PM, Davide Ciminaghi <ciminaghi@gnudd.com> wrote:
> > 
> > > From: Alessandro Rubini <rubini@gnudd.com>
> > >
> > > The header is used by drivers/dma/amba-pl08x.c, which can be compiled
> > > under x86, where PL080 exists under a PCI-to-AMBA bridge. This patche
> > > moves it where it can be accessed by other architectures, and fixes
> > > all users.

Applied, Thanks

--
~Vinod

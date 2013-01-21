Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab3AUFPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 00:15:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:8241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab3AUFPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 00:15:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,504,1355126400"; 
   d="scan'208";a="249968731"
Date: Sun, 20 Jan 2013 20:51:02 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH v4] dw_dmac: don't exceed AHB master number in
 dwc_get_data_width
Message-ID: <20130121045102.GD21551@intel.com>
References: <1358409781-27145-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <CAOh2x=kvAdpaAf11tde=tAcGc=BeVBFr8WgisKseSKoQ5NBr4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOh2x=kvAdpaAf11tde=tAcGc=BeVBFr8WgisKseSKoQ5NBr4w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 01:35:47PM +0530, Viresh Kumar wrote:
> On Thu, Jan 17, 2013 at 1:33 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > The driver assumes that hardware has two AHB masters which might not be always
> > true. In such cases we must not exceed number of the AHB masters present in the
> > hardware. In the proposed scheme in this patch, we would choose the master with
> > highest possible number whenever we exceed max AHB masters.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Applied, Thanks

--
~Vinod

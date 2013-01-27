Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab3A0AKs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:10:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:30927 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764Ab3A0AKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:10:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,545,1355126400"; 
   d="scan'208";a="282615810"
Date: Sun, 27 Jan 2013 01:10:43 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Loic Pallardy <loic.pallardy@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Michel Jaouen <michel.jaouen@st.com>
Subject: Re: [PATCH] mfd: prcmu: delete pin control helpers
Message-ID: <20130127001043.GC1174@sortiz-mobl>
References: <1357546398-9541-1-git-send-email-linus.walleij@stericsson.com>
 <20130122032538.GI7409@sortiz-mobl>
 <CACRpkdaa+bFpmSi8wRiNjyGayP_jW63+_QqbyyNDTPkKinpv5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaa+bFpmSi8wRiNjyGayP_jW63+_QqbyyNDTPkKinpv5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Jan 22, 2013 at 02:25:35PM +0100, Linus Walleij wrote:
> On Tue, Jan 22, 2013 at 4:25 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > On Mon, Jan 07, 2013 at 09:13:18AM +0100, Linus Walleij wrote:
> >> From: Linus Walleij <linus.walleij@linaro.org>
> >>
> >> These static inlines are duplicating the task now done by the
> >> Nomadik pinctrl drivers, so delete them from the prcmu static
> >> inlines, also delete the register definitions as these should
> >> only be known by the pinctrl driver.
> >>
> >> Cc: Loic Pallardy <loic.pallardy@st.com>
> >> Cc: Patrice Chotard <patrice.chotard@st.com>
> >> Cc: Michel Jaouen <michel.jaouen@st.com>
> >> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> >> ---
> >> Sam, this is a pure clean-up patch following the v3.8 merge
> >> window. These inlines are completely unused in the kernel and
> >> I'd simply apply it to the -rc series but it's up to you.
> >
> > Unless it really makes your life easier, I like to keep my -rc pull requests
> > for fixes only.
> > I'll apply it to my for-next branch for now.
> 
> OK in that case, can I take it through the ARM SoC tree
> with your ACK, because I have other cleanups that depend on
> this one?
Fair enough:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

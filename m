Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3AVDZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:25:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:48643 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594Ab3AVDZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:25:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,511,1355126400"; 
   d="scan'208";a="276778867"
Date: Tue, 22 Jan 2013 04:25:38 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Loic Pallardy <loic.pallardy@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Michel Jaouen <michel.jaouen@st.com>
Subject: Re: [PATCH] mfd: prcmu: delete pin control helpers
Message-ID: <20130122032538.GI7409@sortiz-mobl>
References: <1357546398-9541-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357546398-9541-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Jan 07, 2013 at 09:13:18AM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> These static inlines are duplicating the task now done by the
> Nomadik pinctrl drivers, so delete them from the prcmu static
> inlines, also delete the register definitions as these should
> only be known by the pinctrl driver.
> 
> Cc: Loic Pallardy <loic.pallardy@st.com>
> Cc: Patrice Chotard <patrice.chotard@st.com>
> Cc: Michel Jaouen <michel.jaouen@st.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Sam, this is a pure clean-up patch following the v3.8 merge
> window. These inlines are completely unused in the kernel and
> I'd simply apply it to the -rc series but it's up to you.
Unless it really makes your life easier, I like to keep my -rc pull requests
for fixes only.
I'll apply it to my for-next branch for now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

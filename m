Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaK1KzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:55:05 -0500
Received: from mga14.intel.com ([192.55.52.115]:36572 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaK1KzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:55:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,476,1413270000"; 
   d="scan'208";a="629598673"
Date: Fri, 28 Nov 2014 12:54:58 +0200
From: Mika Westerberg <mika.westerberg@intel.com>
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Denis Turischev <denis.turischev@compulab.co.il>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCHv4 1/3] gpio: sch: Consolidate similar algorithms
Message-ID: <20141128105458.GQ1304@lahna.fi.intel.com>
References: <1416977280-27319-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1416977280-27319-2-git-send-email-rebecca.swee.fun.chang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416977280-27319-2-git-send-email-rebecca.swee.fun.chang@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 12:47:58PM +0800, Chang Rebecca Swee Fun wrote:
> Consolidating similar algorithms into common functions to make
> GPIO SCH simpler and manageable.
>
> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
> ---
>  drivers/gpio/gpio-sch.c |   81 ++++++++++++++++-------------------------------
>  1 file changed, 28 insertions(+), 53 deletions(-)

Looks good to me,

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

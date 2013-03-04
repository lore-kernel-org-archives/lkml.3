Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3CDKns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:43:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:23564 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457Ab3CDKnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:43:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="270568227"
Date: Mon, 4 Mar 2013 11:43:39 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ian Lartey <ian@slimlogic.co.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH v2] gpio: palmas: add in GPIO support for palmas charger
Message-ID: <20130304104339.GA25973@sortiz-mobl>
References: <1362157598-11458-1-git-send-email-ian@slimlogic.co.uk>
 <5131ACC3.10803@nvidia.com>
 <20130302193500.783693E1095@localhost>
 <5134758A.8010204@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5134758A.8010204@slimlogic.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On Mon, Mar 04, 2013 at 10:20:58AM +0000, Ian Lartey wrote:
> On 02/03/13 19:35, Grant Likely wrote:
> >On Sat, 2 Mar 2013 13:09:47 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> >>On Friday 01 March 2013 10:36 PM, Ian Lartey wrote:
> >>>Palmas charger has 16 GPIOs
> >>>add palmas_gpio_[read|write|update] api to take account
> >>>second bank of GPIOs
> >>>
> >>>Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> >>>Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> >>>---
> >>
> >>Looks good.
> >>Acked-by: Laxman Dewangan<ldewangan@nvidia.com>
> >>
> >
> >Applied for v3.10, thanks.
> >
> >g.
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >Please read the FAQ at  http://www.tux.org/lkml/
> >
> Hello Grant,
> 
> For this [v2] patch I missed out that this patch depends on
> "[PATCH v2] mfd: palmas: is_palmas_charger needed by multiple drivers."
> I did have this noted in the first version of this patch - sorry.
> 
> kbuild rightly complained about the patch
> 
> Do you want to revert this patch until the
> "mfd: palmas: is_palmas_charger needed by multiple drivers"
> is also accepted ?
You should send your patches as independent patchsets, to be applied in the
right order. I'll ack the MFD patches and Grant could take both.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

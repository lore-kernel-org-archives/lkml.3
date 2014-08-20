Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbaHTJ23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:28:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:58215 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbaHTJ20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:28:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,901,1400050800"; 
   d="scan'208";a="579221136"
Message-ID: <1408526900.14919.0.camel@smile.fi.intel.com>
Subject: Re: [PATCH v1 01/12] dmaengine: dw: move dw_dmac.h to where it
 belongs to
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 20 Aug 2014 12:28:20 +0300
In-Reply-To: <CAOh2x=nxqJkN45TD1xcqgsxndLv2bJ0zSp2Cg_2rVDsdMM6bNw@mail.gmail.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1408469363-15901-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=nxqJkN45TD1xcqgsxndLv2bJ0zSp2Cg_2rVDsdMM6bNw@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2014-08-20 at 14:25 +0530, Viresh Kumar wrote:
> On Tue, Aug 19, 2014 at 10:59 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > There is a common storage for platform data related structures and definitions
> > inside kernel source tree. The patch moves file from include/linux to
> > include/linux/platform_data and renames it acoordingly. The users are also
> > updated.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> 
> >  include/linux/dw_dmac.h                         | 111 ------------------------
> >  include/linux/platform_data/dma-dw.h            | 111 ++++++++++++++++++++++++
> 
> Nice work but wrong git commands to produce this patch..
> Always run format-patch with these options Atleast:
> 
> git format-patch -C -M --thread=shallow
> 
> With the -C -M option you would have got something like:
> 
>  include/linux/{dw_dmac.h => platform_data/dma-dw.h} | 0
> 
> Which would have made review so so easy :)

Thanks for reminding me this, though I thought I would do that way and
*forgot* while rebasing series.

And thanks for Ack!


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab3CGKMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:12:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:41072 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab3CGKMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:12:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,800,1355126400"; 
   d="scan'208";a="296657083"
Date: Thu, 7 Mar 2013 15:17:35 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: gregkh@linuxfoundation.org, djbw@fb.com, nicolas.ferre@atmel.com,
        linus.walleij@linaro.org, rmk+kernel@arm.linux.org.uk,
        jassisinghbrar@gmail.com, lars@metafoo.de, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        "Maxin B. John" <maxin.john@enea.com>
Subject: Re: [PATCH] dma: Remove erroneous __exit and __exit_p() references
Message-ID: <20130307094735.GG13370@intel.com>
References: <1361318824-22287-1-git-send-email-maxin.john@gmail.com>
 <CACRpkdZamOCWHWMcFYRqQDKJARZOCEP_eSNPNaxSgHfAn2wmEw@mail.gmail.com>
 <CAMhs6YwC+Lx0Vt=w2MoQV08on+rB1zidGCsNHRqcst8KBrb2XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMhs6YwC+Lx0Vt=w2MoQV08on+rB1zidGCsNHRqcst8KBrb2XQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 10:17:40AM +0100, Maxin B. John wrote:
> Hi,
> 
> On Fri, Feb 22, 2013 at 7:29 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Wed, Feb 20, 2013 at 1:07 AM,  <maxin.john@gmail.com> wrote:
> >
> >> From: "Maxin B. John" <maxin.john@enea.com>
> >>
> >> Removing the annotation with __exit and referencing with __exit_p()
> >> present in dma driver module remove hooks.
> >>
> >> Part of the __devexit and __devexit_p() purge.
> >>
> >> Signed-off-by: Maxin B. John <maxin.john@enea.com>
> >
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Gentle ping...
???

Its already in my -next

--
~Vinod

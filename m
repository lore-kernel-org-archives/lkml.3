Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbaCTQVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:21:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51096 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750960AbaCTQVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:21:12 -0400
Date: Thu, 20 Mar 2014 17:21:00 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] Documentation: dt: list all compatible strings for at91
Message-ID: <20140320162100.GU12021@piout.net>
References: <1395224808-10133-1-git-send-email-alexandre.belloni@free-electrons.com>
 <CAL_Jsq+sctq85ZhqKyVa7=r5A0FEDKu36692rRJufyca1gzF6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+sctq85ZhqKyVa7=r5A0FEDKu36692rRJufyca1gzF6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On 19/03/2014 at 11:14:43 -0500, Rob Herring wrote :
> On Wed, Mar 19, 2014 at 5:26 AM, Alexandre Belloni
> <alexandre.belloni@free-electrons.com> wrote:
> > Avoids getting the newly introduced warning:
> > WARNING: DT compatible string "atmel,at91sam9g45-adc" appears un-documented -- check ./Documentation/devicetree/bindings/
> > +                               compatible = "atmel,at91sam9g45-adc";
> >
> > Introduced by:
> > bff5da433525 checkpatch: add DT compatible string documentation checks
> 
> We should fix checkpatch instead. There are some fixes in progress,
> but I don't think it covers this issue. I'm puzzled by this one as I
> thought I checked for this case.
> 

Will someone take care of it ? I'm not sure how you want to handle that
as <chip> is replacing different values depending on the context. Also,
while for atmel and freescale, it is replacing the full chip name, that
is not the case for nvidia...

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

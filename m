Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaIVP0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:26:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49603 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753501AbaIVP0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:26:41 -0400
Date: Mon, 22 Sep 2014 17:26:38 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Johan Hovold <johan@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/9] rtc: at91sam9: add DT support
Message-ID: <20140922172638.1c699ec9@bbrezillon>
In-Reply-To: <20140922151754.GH5237@localhost>
References: <1411377058-26155-1-git-send-email-boris.brezillon@free-electrons.com>
	<1411377058-26155-5-git-send-email-boris.brezillon@free-electrons.com>
	<20140922151754.GH5237@localhost>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014 17:17:54 +0200
Johan Hovold <johan@kernel.org> wrote:

> [ Please don't drop people from CC. ]
> 
> On Mon, Sep 22, 2014 at 11:10:53AM +0200, Boris BREZILLON wrote:
> > Add of_match_table to the existing driver so that rtc nodes defined in at91
> > DTs can be attached to this driver.
> 
> That should be rtt nodes.

Oh crap! Hopefully this is the last occurrence of 'rtc' in my commit logs :-).

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

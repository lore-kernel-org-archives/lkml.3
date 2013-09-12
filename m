Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3ILOGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:06:30 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:44005 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab3ILOG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:06:28 -0400
Message-ID: <1378994706.16481.6.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH 1/2] ARM: msm: Add support for MSM8974 Dragonboard
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: David Brown <davidb@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-arm-msm@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 12 Sep 2013 17:05:06 +0300
In-Reply-To: <20130911180006.GA12624@codeaurora.org>
References: <1375743779-24993-1-git-send-email-rvaswani@codeaurora.org>
	 <1375780486.2725.7.camel@iivanov-dev.int.mm-sol.com>
	 <20130911180006.GA12624@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2013-09-11 at 11:00 -0700, David Brown wrote: 
> On Tue, Aug 06, 2013 at 12:14:46PM +0300, Ivan T. Ivanov wrote:
> 
> >Attached patch enables earlyprink for this board.
> >
> >[920] booting linux @ 0x8000, ramdisk @ 0x2000000 (1067699), tags/device tree @ 0x1e00000
> >Uncompressing Linux... done, booting the kernel.
> >[    0.000000] Booting Linux on physical CPU 0x0
> >[    0.000000] Linux version 3.11.0-rc4-00003-g7c8394e (iivanov@dev) (gcc version 4.6.3 (GCC) ) #502 SMP PREEMPT Tue Aug 6 12:09:07 EEST3
> >[    0.000000] CPU: ARMv7 Processor [512f06f0] revision 0 (ARMv7), cr=10c5387d
> >[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
> >[    0.000000] Machine: Qualcomm MSM (Flattened Device Tree), model: Qualcomm MSM8974 Dragonboard
> 
> We'll need to have either Rohit include this in his patch series, or
> you'll have to format this as a valid patch.

I don't have preferences. Rohit could you send this patch 
with you changes?

Regards,
Ivan

> 
> Thanks,
> David
> 



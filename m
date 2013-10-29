Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3J2TYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:24:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40530 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751379Ab3J2TYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:24:43 -0400
Date: Tue, 29 Oct 2013 20:24:39 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sachin.kamat@linaro.org, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 2/2] dma: mv_xor: Use high_base mmio where appropriate
Message-ID: <20131029202439.4740b297@skate>
In-Reply-To: <CAPcyv4iRawGxPwcPhyKCHG+2orVNmPktObR7_TSXwN+6tZ=qog@mail.gmail.com>
References: <1383000855-8377-1-git-send-email-ezequiel.garcia@free-electrons.com>
	<1383000855-8377-2-git-send-email-ezequiel.garcia@free-electrons.com>
	<CAPcyv4iQVoYCXz16T3N4MbdVJV7MoKKeL0wq9t9WF1Kf3gz3Bw@mail.gmail.com>
	<20131029083407.GA2416@localhost>
	<20131029103229.5e095a24@skate>
	<CAPcyv4iRawGxPwcPhyKCHG+2orVNmPktObR7_TSXwN+6tZ=qog@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Dan Williams,

On Tue, 29 Oct 2013 12:15:18 -0700, Dan Williams wrote:

> > I agree with Ezequiel, and I believe his patch is appropriate. The
> > registers for the XOR engines are indeed split in two areas, so it
> > makes sense to have this xor_base / xor_high_base split that reflects
> > the register mapping passed from the Device Tree, and use this split in
> > the macros used to access the registers.
> >
> 
> Ah ok, so it's a bug if an implementation ever puts the second
> resource window at a non 0x200 offset.

Exactly.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

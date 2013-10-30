Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab3J3AlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:41:04 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:57050 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab3J3AlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:41:01 -0400
MIME-Version: 1.0
In-Reply-To: <20131030003317.GD2527@localhost>
References: <1383000855-8377-1-git-send-email-ezequiel.garcia@free-electrons.com>
	<1383000855-8377-2-git-send-email-ezequiel.garcia@free-electrons.com>
	<CAPcyv4iQVoYCXz16T3N4MbdVJV7MoKKeL0wq9t9WF1Kf3gz3Bw@mail.gmail.com>
	<20131029083407.GA2416@localhost>
	<20131029103229.5e095a24@skate>
	<CAPcyv4iRawGxPwcPhyKCHG+2orVNmPktObR7_TSXwN+6tZ=qog@mail.gmail.com>
	<20131030003317.GD2527@localhost>
Date: Tue, 29 Oct 2013 17:40:59 -0700
Message-ID: <CAPcyv4gMCSBeQbT6tCoJPLwXLe36iOCtL+HLhhzvA1=S_qBoYA@mail.gmail.com>
Subject: Re: [PATCH 2/2] dma: mv_xor: Use high_base mmio where appropriate
From: Dan Williams <dan.j.williams@intel.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sachin.kamat@linaro.org, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 5:33 PM, Ezequiel Garcia
<ezequiel.garcia@free-electrons.com> wrote:
> By the way, I didn't initially Cced dmaengine list because it's not
> in the MAINTAINERS file.
>
> How about we add it and avoid this happening to other developers?

It's there now, but we just created it so you happened to be one of
the first ones through...

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/MAINTAINERS#n2728

--
Dan

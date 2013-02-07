Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176Ab3BGRZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:25:09 -0500
Received: from service87.mimecast.com ([91.220.42.44]:43227 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759157Ab3BGRZF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:25:05 -0500
Date: Thu, 7 Feb 2013 17:25:01 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCHv3 4/4] arm: Add generic timer broadcast support
Message-ID: <20130207172501.GC28072@e106331-lin.cambridge.arm.com>
References: <1358183124-28461-1-git-send-email-mark.rutland@arm.com>
 <1358183124-28461-5-git-send-email-mark.rutland@arm.com>
 <5112C25F.6000508@wwwdotorg.org>
 <20130207100403.GD16987@e106331-lin.cambridge.arm.com>
 <5113DB2F.9090606@wwwdotorg.org>
MIME-Version: 1.0
In-Reply-To: <5113DB2F.9090606@wwwdotorg.org>
Thread-Topic: [PATCHv3 4/4] arm: Add generic timer broadcast support
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Feb 2013 17:25:02.0454 (UTC) FILETIME=[1007F160:01CE0558]
X-MC-Unique: 113020717250304801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> > The intent of 12ad100046: "clockevents: Add generic timer broadcast function"
> > was to setup the broadcast function both for non-functional/dummy timers and
> > those that stop in low-power states (CLOCK_EVT_FEAT_C3STOP). I missed the
> > CLOCK_EVT_FEAT_C3STOP case.
> > 
> > I believe the patch below will fix this for Tegra and any other platforms where
> > broadcast is required in low power states.
> > 
> > Stephen, could you test this for Tegra?
> 
> Tested-by: Stephen Warren <swarren@nvidia.com>

Thanks. Sorry for the bother.

Mark.


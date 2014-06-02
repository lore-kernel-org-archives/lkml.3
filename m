Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbaFBOh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:37:26 -0400
Received: from trinity.fluff.org ([89.16.178.74]:45938 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbaFBOhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:37:24 -0400
Date: Mon, 2 Jun 2014 15:37:20 +0100
From: Ben Dooks <ben@trinity.fluff.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Linus <torvalds@linux-foundation.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Chris Ball <chris@printf.net>
Subject: Re: [GIT PULL] MMC for v.3.16
Message-ID: <20140602143720.GB19809@trinity.fluff.org>
References: <CAPDyKFpkKNx17ha=WWAp4-6w3k4pRYSHUhOWHv1G+1_wAEBceA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFpkKNx17ha=WWAp4-6w3k4pRYSHUhOWHv1G+1_wAEBceA@mail.gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 02:03:27PM +0200, Ulf Hansson wrote:
> Hi Linus,
> 
> This is the first PR I send to you as I am co-maintaining the MMC
> subsystem with Chris Ball. You will receive a separate PR for MMC from
> him as well, as usual.
> 
> These patches are mainly updates for the mmci driver and have been
> tested in linux-next.
> 
> Some ARM SoC related patches are also included and those have been
> acked from the corresponding maintainers to go through my mmc tree.
> 
> Some more details in the signed tag.
> 
> Kind regards
> Ulf Hansson

Hi, is it too late to get the sh-mmcif driver cleanups in? I posted
them some time ago but they do not seem to have been applied.


-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab3GKLKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:10:48 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:57156 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab3GKLKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:10:47 -0400
Date: Thu, 11 Jul 2013 12:10:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Ankur Raina <Ankur.Raina@kpitcummins.com>
Cc: sameo@linux.intel.com, broonie@kernel.org, axel.lin@gmail.com,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        david.chen@diasemi.com
Subject: Re: [patch v1]mfd: fix for DA9055 driver initialization
Message-ID: <20130711111040.GG25601@gmail.com>
References: <1373030310.1601.30.camel@ankurr1-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1373030310.1601.30.camel@ankurr1-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Jul 2013, Ankur Raina wrote:

> This patch clears all the events received while powering up DA9055.
> While powering up DA9055,power sequencer and gpio events are received.
> These events remain uncleared after boot up, due to which further event handling also fails.
> DA9055 has three event registers.The event register bits are set to '1' on receiving an event.
> The events can be cleared on writing a '1' to the set bit, which would then clear that bit to '0'
> After applying this patch we have a clean state after boot up.
> 
> Signed-off-by: Ankur Raina <Ankur.Raina@kpitcummins.com>
> ---
>  drivers/mfd/da9055-core.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)

I'm going to clean up the commit message a little then apply this patch.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

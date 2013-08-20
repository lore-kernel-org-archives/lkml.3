Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab3HTNBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 09:01:42 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:50491 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3HTNBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 09:01:39 -0400
Date: Tue, 20 Aug 2013 14:01:34 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Florian Lobmaier <Florian.Lobmaier@ams.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Subject: Re: mfd: as3722: introducing ams AS3722 PMIC driver
Message-ID: <20130820130134.GP23699@lee--X1>
References: <1376997210-32631-1-git-send-email-florian.lobmaier@ams.com>
 <20130820123237.GO23699@lee--X1>
 <EB31996D403C2C48A47628A08DCCFD2901857BCEF5@SUX2182.office.amsiag.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EB31996D403C2C48A47628A08DCCFD2901857BCEF5@SUX2182.office.amsiag.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Florian Lobmaier wrote:
> On Tue, 20 Aug 2013, Lee Jones wrote:
> > - http://kparal.wordpress.com/2011/08/18/git-tip-of-the-day-splitting-changes-into-several-patches/
> 
> > - http://nuclearsquid.com/writings/git-add/
> 
> Thank you very much for your hints and clarification on how to split up the patches. I think this point is clear to me now. We will need of course some time to split up the patches as requested.

No problem. Take as much time as you need.

> In addition, how to deal with the sub-drivers of the mfd? Should those be included in the mfd driver patch as they are introduced or should they be treated as separate units?

As long as each commit can be built as it's added and the pieces are
kept reasonably small, it doesn't matter too much. In an ideal world
each patch will only pertain to a single file, but sometimes adding
something in one file doesn't make any sense without the addition of
corresponding code in a related driver.

Just try to keep them separate with regards to subsystems, or else
matter will be complicated somewhat.

> Thanks again for your help, but as you might have already recognized, we are kernel newbies. At least in terms of getting code upstream.

That's fine. Everyone has to start from somewhere.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

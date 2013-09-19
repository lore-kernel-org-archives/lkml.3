Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3ISKdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:33:16 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:42709 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab3ISKdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:33:15 -0400
Date: Thu, 19 Sep 2013 11:33:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Christian Daudt <csd@broadcom.com>
Cc: Christian Daudt <csd_b@daudt.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 06/22] ARM: dts: bcm281xx: Remove '0x's from BCM11351 DTS
 file
Message-ID: <20130919103303.GC22389@lee--X1>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-6-git-send-email-lee.jones@linaro.org>
 <51EDAC90.6010108@broadcom.com>
 <20130723075309.GE26801@laptop>
 <CAGFynZ-+UoML32ecX4nSGAaFJXqQpdq+D8j7GqJSKhxsE7w=9A@mail.gmail.com>
 <20130812135439.GF13851@lee--X1>
 <523A2EEF.3070406@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <523A2EEF.3070406@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Sep 2013, Christian Daudt wrote:

> On 13-08-12 06:54 AM, Lee Jones wrote:
> >On Thu, 08 Aug 2013, Christian Daudt wrote:
> >
> >>Hi Lee,
> >>  I had to change some of the lines in the dts files you modified, so
> >>I've added your mods. This patch:
> >>https://lkml.org/lkml/2013/8/8/477
> >>
> >>includes your changes to bcm11351.dtsi and bcm11351-brt.dts. Not sure
> >>where your patch is at this point, but I just wanted to point that
> >>out.
> >I haven't done anything with that patch yet, but I'd prefer they
> >stayed separate to be honest. If you make your changes and ensure
> >they're in an upstream tree (and let me know which one), I'll rebase
> >my patches on top of that tree.
> 
> These changes are in 3.12-rc1 now:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d7358f845645c588aff84ac6b476a17d3eec75fa

Not even so much as a Reviewed-by:, nice!

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

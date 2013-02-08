Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946058Ab3BHIU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:20:59 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:46499 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759790Ab3BHIU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:20:57 -0500
Date: Fri, 8 Feb 2013 08:20:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH 01/49] regulator: ab8500: Further populate initialisation
 registers
Message-ID: <20130208082050.GE7519@gmail.com>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
 <1360148051-7560-2-git-send-email-lee.jones@linaro.org>
 <20130207184549.GA8879@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130207184549.GA8879@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2013, Mark Brown wrote:

> On Wed, Feb 06, 2013 at 10:53:23AM +0000, Lee Jones wrote:
> > This patch supplies access to some extra settings provided by the
> > AB8500 regulator device. We also update some of the existing
> > initialisation values in accordance with internal ST-Ericsson code
> > submissions. This single patch was originally a collection of updates
> > which have been squashed together to aid with clarity.
> 
> I tried to apply this but got conflicts - can you please check what's
> going on with this vs my topic/ab8500 branch?

It's almost certainly because you're trying to pull the patches in out
of order. This _will_ end in conflicts. Any chance you can start from
01 and work your way though them. I will fixup any that you don't like
on the fly.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

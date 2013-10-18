Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab3JRGxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 02:53:53 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:50908 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3JRGxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 02:53:52 -0400
Date: Fri, 18 Oct 2013 07:53:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>, lgirdwood@gmail.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/3 v2] regulator: core: Add ability to create a lookup
 alias for supply
Message-ID: <20131018065345.GR19112@lee--X1>
References: <1381864462-26167-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1381864462-26167-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131017235940.GB2443@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131017235940.GB2443@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013, Mark Brown wrote:

> On Tue, Oct 15, 2013 at 08:14:20PM +0100, Charles Keepax wrote:
> > These patches add the ability to create an alternative device on which
> > a lookup for a certain supply should be conducted.
> 
> Applied, thanks.  This can't really be applied without pulling in large
> chunks of the regulator changes due to some refactoring in the core that
> it depends on, I've created a tag supply-alias but it's got a nasty diff
> so it's probably best if I apply the other two patches to the regulator
> tree?

If you're happy with the other two patches, I am. Would you mind
reviewing and providing your Ack? Once I have it, I'll setup a branch
you can pull from in my MFD tree.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

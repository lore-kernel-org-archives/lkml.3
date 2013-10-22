Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab3JVRAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:00:53 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:46890 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab3JVRAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:00:52 -0400
Date: Tue, 22 Oct 2013 18:00:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>, lgirdwood@gmail.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/3 v2] regulator: core: Add ability to create a lookup
 alias for supply
Message-ID: <20131022170047.GA2620@lee--X1>
References: <1381864462-26167-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1381864462-26167-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131017235940.GB2443@sirena.org.uk>
 <20131018065345.GR19112@lee--X1>
 <20131018130643.GN2443@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131018130643.GN2443@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013, Mark Brown wrote:

> On Fri, Oct 18, 2013 at 07:53:45AM +0100, Lee Jones wrote:
> 
> > If you're happy with the other two patches, I am. Would you mind
> > reviewing and providing your Ack? Once I have it, I'll setup a branch
> > you can pull from in my MFD tree.
> 
> Acked-by: Mark Brown <broonie@linaro.org>
> 
> but those patches will fail to build without the preceeding regulator
> patch (which is in my tree, there's a signed commit supply-alias but it
> pulls along an awfully large diffstat sadly).

Okay, fair enough.

In which case, just take the patches and apply my Ack.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3H3M0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:26:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:6987 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab3H3M0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:26:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,990,1367996400"; 
   d="scan'208";a="394500571"
Date: Fri, 30 Aug 2013 14:26:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Chris Ball <cjb@laptop.org>
Cc: wwang <wei_wang@realsil.com.cn>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 0/3] Fix sd3.0 issues for Realtek card reader
Message-ID: <20130830122642.GJ20329@zurbaran>
References: <cover.1377049122.git.wei_wang@realsil.com.cn>
 <521C0F2E.9050904@realsil.com.cn>
 <86ppswc4u6.fsf@void.printf.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86ppswc4u6.fsf@void.printf.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Fri, Aug 30, 2013 at 03:03:45AM +0100, Chris Ball wrote:
> Hi,
> 
> On Tue, Aug 27 2013, wwang wrote:
> > 于 2013年08月21日 09:46, wei_wang@realsil.com.cn 写道:
> >> From: Wei WANG <wei_wang@realsil.com.cn>
> >>
> >> Wei WANG (3):
> >>   mfd:mmc:rtsx: Change default tx phase
> >>   mmc:rtsx:Clear SD_CLK toggle enable bit if switching voltage fail
> >>   mmc:memstick:rtsx: Modify copyright comments
> >>
> >>  drivers/memstick/host/rtsx_pci_ms.c |    3 +-
> >>  drivers/mfd/rtl8411.c               |    4 ++
> >>  drivers/mfd/rts5209.c               |    2 +
> >>  drivers/mfd/rts5227.c               |    2 +
> >>  drivers/mfd/rts5229.c               |    2 +
> >>  drivers/mfd/rts5249.c               |    2 +
> >>  drivers/mmc/host/rtsx_pci_sdmmc.c   |   70 +++++++++++++++++++++++++----------
> >>  include/linux/mfd/rtsx_pci.h        |   15 ++++++++
> >>  8 files changed, 79 insertions(+), 21 deletions(-)
> >>
> >
> > Can you help to review this patchset? I want to submit it to 3.12 kernel.
> > And Lee Jones has acked the MFD parts.
> 
> The patchset looks fine, but it depends on MFD changes that aren't in
> my mmc-next tree, and I don't want to invalidate my mmc-next testing
> by updating my tree.  Maybe the MFD maintainer could take it with my Ack?
> 
> If so:
> 
>    Acked-by: Chris Ball <cjb@laptop.org>
Thanks. I applied this patchset through the MFD tree, with Lee and your ACKs.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

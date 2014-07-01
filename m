Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964787AbaGAOPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:15:43 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:37835 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573AbaGAOO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:14:57 -0400
Date: Tue, 1 Jul 2014 15:14:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mark Brown <broonie@linaro.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Carlo Caione <carlo@caione.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH resend v2 1/3] mfd-core: Don't register supplies from
 add_device, add register_supply_aliases()
Message-ID: <20140701141450.GL27971@lee--X1>
References: <1404138369-23907-1-git-send-email-hdegoede@redhat.com>
 <1404138369-23907-2-git-send-email-hdegoede@redhat.com>
 <20140701092255.GF27971@lee--X1>
 <53B2818F.8060705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53B2818F.8060705@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jul 2014, Hans de Goede wrote:
> On 07/01/2014 11:22 AM, Lee Jones wrote:
> > On Mon, 30 Jun 2014, Hans de Goede wrote:
> > 
> >> We cannot register supply alias in mfd_add_device before calling
> >> platform_add_device because platform-dev's name must be set before registering
> >> the aliases which happens from platform_add_device.
> >>
> >> So stop registering supply aliases from mfd_add_device, and add a
> >> mfd_register_supply_aliases helper functions for the cell's plaform driver
> >> probe method to use.
> >>
> >> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> > 
> > Didn't I already Ack this?
> 
> Ah yes you did, but back then I expected the series to get picked up
> immediately, so I did not add the ack to my local copy of it.

When resubmitting, it's always a good idea to look at previous review
in order to search for review comments to fix, or Acks to apply.
Unfortunately the set couldn't go in without Mark's review - which is
still the case.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaATSlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:41:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51924 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaATSlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:41:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Srikanth Thokala <sthokal@xilinx.com>
Subject: Re: [PATCH] dma: Add Xilinx AXI Video Direct Memory Access Engine driver support
Date: Mon, 20 Jan 2014 19:41:07 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, michal.simek@xilinx.com,
        Grant Likely <grant.likely@linaro.org>, robh+dt@kernel.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1389894803-4147-1-git-send-email-sthokal@xilinx.com> <201401201239.47665.arnd@arndb.de> <CA+mB=1+mrWAzBCxdMEji2MDRzHajmnxuWtz7iu96ML0DuAB3RQ@mail.gmail.com>
In-Reply-To: <CA+mB=1+mrWAzBCxdMEji2MDRzHajmnxuWtz7iu96ML0DuAB3RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401201941.07633.arnd@arndb.de>
X-Provags-ID: V02:K0:NSVVJiWv5/yhOcthNo0krE3W+Dkd4rtx9fK1MiLACOe
 tBJbPk2Pt+RUIwtefGg9W6xkLKvgLqjHgP2FX4okZFb7dDxDoC
 M+FDETDlYvQf8TjCGZa4hmvaiOg1XSjXMjLqVLM2Jwj8H3rzh/
 hCMniuIoSs9mwBD1yQhQMKpRqWd5LoiyYxMhGVmddx1gIIkZEr
 7ASw8ufb51gJV/d+SFcOZpSFh5ie1fnE4oEhFB16z91q4u3AGB
 smADQJZsJqtECoNUMxaHAZybs9lpLgWlXdWWOgISctM3goV+im
 z2Of430g4loDAc7rzBffq6auZl4Qk1pNhWNuwZ5zsuMW9zxJqN
 Wuq4vd0pU/gwcEGKPC9w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 January 2014, Srikanth Thokala wrote:
> >
> >> > * data width should be a property of the slave driver that is configured
> >> >   through dma_slave_config(), unless you can have dma engines that only
> >> >   support certain a width.
> >>
> >> Yes, this VDMA engine soft IP support only certain widths, which is
> >> configurable during IP synthesis.
> >
> > But what is this property used for in that case? Surely you can't
> > connect a slave device to a dmaengine if the bus width doesn't match.
> > You probably have a point here, but I don't understand it yet.
> 
> There is a Data-Realignment Engine (DRE) in the IP which is only available for
> data width setting of 64-bits and less.  So, we use the data-width DT parameter
> to verify this condition and we update alignment shift accordingly.

Ok, I have to admit I didn't understand all of that, but you clearly
know what you are talking about here, so I assume you are correct.

	Arnd

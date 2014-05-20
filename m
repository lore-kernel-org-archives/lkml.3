Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbaETQue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:50:34 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45717 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbaETQud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:50:33 -0400
Date: Tue, 20 May 2014 17:50:28 +0100
From: Lee Jones <lee.jones@linaro.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "Zhu, Lejun" <lejun.zhu@linux.intel.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, bin.yang@intel.com
Subject: Re: [PATCH 0/4] mfd: Intel SoC Power Management IC
Message-ID: <20140520165027.GA32538@lee--X1>
References: <1400079578-32329-1-git-send-email-lejun.zhu@linux.intel.com>
 <20140520145507.GU24991@lee--X1>
 <20140520160708.1382a6ab@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140520160708.1382a6ab@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm missing the build files patch.  Can you ensure I was on the
> > distribution list please?  Also, what's the reason for splitting the
> > files out instead of having one single driver?
> 
> The same PMIC may be attached multiple ways, and multiple different PMIC
> types may be attached.
> 
> So for example on the Baytrail/T platforms (ASUS T100 etc) you have
> crystal cove via i2c, but a vendor could use a different PMIC - and there
> will of course always be new PMIC devices coming along.
> 
> Equally on a Z2760 or similar (eg the Lenovo tablet 2) you may well have
> the same PMIC attached to the system control unit. While there's nobody
> afaik trying to sync the Android trees for Clovertrail+ with upstream at
> this point I know there are external to Intel folks working on it for fun
> and we need to allow for that.

Fair enough, I'll bow to your knowledge.  I was just looking at the
current driver and saw the lack of, for instance, intel_soc_pmic_spi.c
which would have warranted separate core/i2c/spi components.  Also the
Kconfig configuration doesn't allow for individual compilation of each
of the source files, which drew me to the conclusion that these could
in fact be centralised.
-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965258AbaDJHeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:34:01 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:35423 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaDJHd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:33:59 -0400
Date: Thu, 10 Apr 2014 08:33:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v4 00/16] mfd: max14577: Add support for MAX77836
Message-ID: <20140410073354.GC4214@lee--X1>
References: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
 <53461E09.7090408@samsung.com>
 <1397112697.6717.2.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397112697.6717.2.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hi Krzysztof,
> > 
> > Did you finish this patchset for applying git repository?
> > I can't find this patchset on mainline kernel.
> > 
> > If this patchset isn't applied on mainline, I'd like you to finish this patch
> > because I want to maintain up to date patch for max77836/max14577 on mainline.
> 
> Hi,
> 
> The patches didn't get to mainline. I couldn't obtain all needed acks. I
> prepared another version of the patchset (with less cross-subsystem
> renames) which I plan to send after 3.15 merge window.

If this is technically possible it should always be the default as it
makes things easier for everyone.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

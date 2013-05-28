Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262Ab3E1XRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:17:43 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:59521 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759091Ab3E1XRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:17:41 -0400
Date: Tue, 28 May 2013 16:17:40 -0700
From: Olof Johansson <olof@lixom.net>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        dianders@chromium.org, patches@linaro.org
Subject: Re: [PATCH] ARM: EXYNOS: Update defconfig for Arndale and Origen
 board
Message-ID: <20130528231740.GA28879@quad.lixom.net>
References: <1368168599-28507-1-git-send-email-tushar.behera@linaro.org>
 <87sj1qzaov.fsf@linaro.org>
 <5191AA89.6010901@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5191AA89.6010901@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 08:37:53AM +0530, Tushar Behera wrote:
> On 05/14/2013 05:36 AM, Kevin Hilman wrote:
> > Tushar Behera <tushar.behera@linaro.org> writes:
> > 
> >> It updates following drivers for EXYNOS based DT platform.
> >>
> >> * S5M8767 driver
> >> * MAX8997 driver
> >> * MMC SDHCI driver
> >>
> >> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> > 
> > I tested this using v3.10-rc1 on Arndale, but still don't get any
> > support for the wired network.  Do you know if this is a Kconfig issue,
> > or a missing driver?
> > 
> > I suspect it may be related to the various "unable to find transceiver
> > of type USB2 PHY" messages I'm seeing?
> > 
> 
> Yes, right. The missing USB-PHY components are one of the issues (they
> were there in linux-next when I last tested).
> 
> Also, on Arndale board, we need to reset the USB hub during EHCI
> initialization (a couple of those patches are required, which I am not
> sure if we would be able to upstream).
> 
> I am collecting a minimal set of patches that would enable USB and wired
> network on Arndale with 3.10-rc1 kernel. Once done, I will let you know.

Hi Tushar,

Got an update on what these patches are yet?


-Olof


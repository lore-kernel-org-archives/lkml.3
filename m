Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbaHGNym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:54:42 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33594 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712AbaHGNyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:54:39 -0400
Date: Thu, 7 Aug 2014 14:54:32 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, ajitpal.singh@st.com
Subject: Re: [PATCH v2 00/11] pwm: Introduce ST's PWM driver
Message-ID: <20140807135432.GB21618@lee--X1>
References: <1405348412-7352-1-git-send-email-lee.jones@linaro.org>
 <20140721123950.GY30888@lee--X1>
 <20140807132050.GC1540@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140807132050.GC1540@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Aug 2014, Thierry Reding wrote:

> On Mon, Jul 21, 2014 at 01:39:50PM +0100, Lee Jones wrote:
> > Hi Thierry,
> > 
> > Did you find some time to look at this set?
> 
> Sorry for the long delay. I've applied patches 6-11 to the PWM tree,
> though I've modified patch 6 a little for consistency. The module is
> now named after the Kconfig option (pwm-sti rather than pwm-st). The
> dependencies also seem to be redundant (ARCH_STI already depends on
> OF), though I didn't change that just in case it's required for some
> other reason.
> 
> Anyway, scream if there's anything in the PWM for-next branch that
> needs to be fixed up.

And in time for v3.17.  Nice one, thanks Thierry.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

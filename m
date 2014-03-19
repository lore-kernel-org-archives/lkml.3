Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791AbaCSIh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:37:27 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36688 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595AbaCSIhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:37:23 -0400
Date: Wed, 19 Mar 2014 08:37:18 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: sec-core: Fix I2C dummy device resource leak on
 probe failure
Message-ID: <20140319083718.GA31687@lee--X1>
References: <1395147470-24817-1-git-send-email-k.kozlowski@samsung.com>
 <CAK9yfHx=3KR0WyrtmZXbYJ3MXM9vAsCzh=EKORfiifzhL2Ud8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9yfHx=3KR0WyrtmZXbYJ3MXM9vAsCzh=EKORfiifzhL2Ud8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 18 March 2014 18:27, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > Dummy I2C device allocated in sec_pmic_probe() leaked if
> > devm_regmap_init_i2c() failed. Unregister it before returning from
> > probe.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> Looks good.
> Reviewed-by: Sachin Kamat <sachin.kamat@linaro.org>

Applied with Sachin's Ack.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

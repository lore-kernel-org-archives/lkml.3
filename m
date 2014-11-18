Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbaKRIZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:25:37 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:39335 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaKRIZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:25:34 -0500
Date: Tue, 18 Nov 2014 08:25:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, broonie@kernel.org,
        mturquette@linaro.org, a.zummo@towertech.it, lgirdwood@gmail.com,
        sameo@linux.intel.com, geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 4/5] rtc: s5m: Add the support for S2MPS13 RTC
Message-ID: <20141118082527.GV24004@x1>
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-5-git-send-email-cw00.choi@samsung.com>
 <012401d002c8$04efe610$0ecfb230$@samsung.com>
 <546A98EC.8090009@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <546A98EC.8090009@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Chanwoo Choi wrote:

> Dear Sangbeom,
> 
> On 11/18/2014 09:38 AM, Sangbeom Kim wrote:
> > Hi,
> > On Monday, November 17, 2014 9:43 AM, Chanwoo Choi wrote:
> >> This patch adds only the compatible string for S2MPS13 clock which is identical
> >> with S2MPS14 clock driver.
> > 
> > What's the relation of S2MPS14 RTC and clock driver?
> 
> I checked the difference between S2MPS13 and S2MPS14.
> But, all register (RTC) of both PMICs was the same completely.
> So, I just add S2MPS13 type to use existing S2MPS14 RTC feature for S2MPS13 RTC.

Okay, so it looks like this requires another submission.  Please add
the fixup I requested in the first patch.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

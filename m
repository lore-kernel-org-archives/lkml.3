Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaCFJSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:18:48 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:39541 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaCFJSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:18:38 -0500
Date: Thu, 6 Mar 2014 17:18:30 +0800
From: Lee Jones <lee.jones@linaro.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 4/6] rtc: pm8xxx: add support for devicetree
Message-ID: <20140306091830.GB16034@lee--X1>
References: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
 <1394047776-13827-5-git-send-email-joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394047776-13827-5-git-send-email-joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add support for describing the PM8921/PM8058 RTC in device tree.
> 
> Additionally:
>    - drop support for describing the RTC using platform data,
>      as there are no current in tree users who do so.
>    - make allow_set_time a device-specific flag, instead of mucking
>      with the rtc_ops
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  drivers/rtc/rtc-pm8xxx.c       | 54 +++++++++++++++++++++++-------------------
>  include/linux/mfd/pm8xxx/rtc.h | 25 -------------------

For the MFD changes@:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbaHGKIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 06:08:17 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:49180 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbaHGKIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 06:08:16 -0400
Date: Thu, 7 Aug 2014 11:08:09 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wei-Chun Pan <weichun.pan@advantech.com.tw>
Cc: Guenter Roeck <linux@roeck-us.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@the-dreams.de>,
        "Louis.Lu" <Louis.Lu@advantech.com.tw>,
        "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] imanager2: rename io functions and remove no used
 functions
Message-ID: <20140807100809.GG10136@lee--X1>
References: <1407403213-3546-1-git-send-email-weichun.pan@advantech.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407403213-3546-1-git-send-email-weichun.pan@advantech.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be a commit log here.  Explain what you're doing and why.

> Signed-off-by: Wei-Chun Pan <weichun.pan@advantech.com.tw>
> ---
>  drivers/hwmon/imanager2_hwm.c    | 27 +++++------
>  drivers/mfd/imanager2_core.c     | 64 +++++++++++---------------
>  drivers/mfd/imanager2_ec.c       | 99 ++++++++--------------------------------
>  include/linux/mfd/imanager2_ec.h | 24 ++++------
>  4 files changed, 67 insertions(+), 147 deletions(-)

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

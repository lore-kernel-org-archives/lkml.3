Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab3DRR4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:56:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:63938 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab3DRR4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:56:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,503,1363158000"; 
   d="scan'208";a="320428942"
Date: Thu, 18 Apr 2013 19:56:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: mchehab@redhat.com, hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 11/12] si476x: Fix some config dependencies and a compile
 warnings
Message-ID: <20130418175617.GW8798@zurbaran>
References: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
 <1366304318-29620-12-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1366304318-29620-12-git-send-email-andrew.smirnov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 09:58:37AM -0700, Andrey Smirnov wrote:
> From: Hans Verkuil <hverkuil@xs4all.nl>
> 
> radio-si476x depends on SND and SND_SOC, the mfd driver should select
> REGMAP_I2C.
> 
> Also fix a small compile warning in a debug message:
> 
> drivers/mfd/si476x-i2c.c: In function ‘si476x_core_drain_rds_fifo’:
> drivers/mfd/si476x-i2c.c:391:4: warning: field width specifier ‘*’ expects argument of type ‘int’, but argument 4 has type ‘long unsigned int’ [-Wformat]
> 
> Acked-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/radio/Kconfig |    2 +-
>  drivers/mfd/Kconfig         |    1 +
>  drivers/mfd/si476x-i2c.c    |    2 +-
You should have merged the MFD bits from this patch into one of the first 4
patches, that are MFD related. Or at least separated those 2 changes into 2
patches...

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

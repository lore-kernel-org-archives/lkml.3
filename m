Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3JQMmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:42:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:24926 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045Ab3JQMl6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:41:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,514,1378882800"; 
   d="scan'208";a="376082853"
Message-ID: <1382013695.29062.141.camel@smile>
Subject: Re: [PATCH] gpiolib: append SFI helpers for GPIO API
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, sfi-devel@simplefirmware.org,
        linux-gpio@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, Len Brown <lenb@kernel.org>
Date: Thu, 17 Oct 2013 15:41:35 +0300
In-Reply-To: <1381979015-28980-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1381979015-28980-1-git-send-email-david.a.cohen@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 20:03 -0700, David Cohen wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> To support some (legacy) firmwares and platforms let's make life easier for
> their customers.
> 


> +int sfi_get_gpio_by_name(const char *name)
> +{
> +	struct sfi_gpio_table_entry *pentry = sfi_gpio_table;
> +	int i;
> +
> +	if (!pentry)
> +		return -1;

^^^^ It seems an old version.

New version was published while ago and even has an ACK from Linus:

http://www.spinics.net/lists/kernel/msg1545960.html


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

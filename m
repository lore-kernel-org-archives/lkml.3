Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaJNKgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 06:36:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:10512 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbaJNKgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 06:36:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="399935057"
Message-ID: <543CFC7F.2070607@linux.intel.com>
Date: Tue, 14 Oct 2014 13:35:43 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>, linus.walleij@linaro.org,
        gnurou@gmail.com
CC: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [RFC/PATCH] gpio/pinctrl: baytrail: move gpio driver from pinctrl
 to gpio directory
References: <1413227857-555-1-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1413227857-555-1-git-send-email-david.a.cohen@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.10.2014 22:17, David Cohen wrote:
> Even though GPIO module on Intel Bay Trail is able to control pin
> functionality, it's unlikely Linux kernel driver will ever support it
> since BIOS should handle all pin muxing itself.
> 
> Currently this driver does not register any pinctrl interface and
> doesn't call any pinctrl interface. It just uses on internal functions
> the 'struct pinctrl_gpio_range', which is a weak justification to not be
> under gpio directory.
> 

This discussion was held when gpio-baytrail was first submitted.
These threads explain the gpio/pinctrl-baytrail history:

http://marc.info/?l=linux-kernel&m=136981432427668&w=2
http://marc.info/?l=linux-kernel&m=137113578604763&w=2
http://marc.info/?l=linux-kernel&m=137155497023054&w=2

A proper pinctrl driver for baytrail is still not yet ruled out

-Mathias 


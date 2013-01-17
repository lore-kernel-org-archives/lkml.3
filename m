Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab3AQKfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:35:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55022 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757731Ab3AQKfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:35:37 -0500
Date: Thu, 17 Jan 2013 19:35:30 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, sameo@linux.intel.com,
        grant.likely@secretlab.ca, akpm@linux-foundation.org,
        a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 3/4] gpio: palmas: Add support for Palams GPIO
Message-ID: <20130117103529.GB7504@opensource.wolfsonmicro.com>
References: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
 <1357210020-19876-4-git-send-email-ldewangan@nvidia.com>
 <CACRpkdazCa_GMfrCnoYukiQKbKD41RiTG-MyO-5p+B-6-+Y=hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdazCa_GMfrCnoYukiQKbKD41RiTG-MyO-5p+B-6-+Y=hA@mail.gmail.com>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 11:34:42AM +0100, Linus Walleij wrote:

> Do you want me to apply it to my GPIO tree or does it have
> dependencies so you'll take it through MFD or something?

The MFD has been merged for a couple of releases now.

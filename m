Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965609AbaGPR0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:26:51 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:55407 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965257AbaGPR0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:26:48 -0400
Date: Wed, 16 Jul 2014 19:26:46 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LINUX-KERNEL <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        RTC-LINUX <rtc-linux@googlegroups.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Support Opensource" <support.opensource@diasemi.com>
Subject: Re: [RFC V1] mfd: da9063: Add support for AD silicon variant
Message-ID: <20140716192646.4a981b31@linux.lan.towertech.it>
In-Reply-To: <201407161655.s6GGtsHS030285@swsrvapps-01.diasemi.com>
References: <201407161655.s6GGtsHS030285@swsrvapps-01.diasemi.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014 17:39:20 +0100
"Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com> wrote:

> The DA9063 probe function has been modified to use the compile time
> directive CONFIG_MFD_DA9063_AD. This configuration option will allow
> AD support only if this boolean is true, otherwise it will default to
> support BB (or greater) silicon.

 any particular reason for not supporting both at the same time,
 either with a module option, platform data, dt, etc ?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it


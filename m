Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965488AbaGPPrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:47:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:22922 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964942AbaGPPrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:47:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,673,1400050800"; 
   d="scan'208";a="570780941"
Message-ID: <53C69E64.4030801@iki.fi>
Date: Wed, 16 Jul 2014 18:46:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:29.0) Gecko/20100101 SeaMonkey/2.26.1
MIME-Version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH/RFC v4 05/21] leds: avoid using deprecated DEVICE_ATTR
 macro
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com> <1405087464-13762-6-git-send-email-j.anaszewski@samsung.com>
In-Reply-To: <1405087464-13762-6-git-send-email-j.anaszewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

Jacek Anaszewski wrote:
> Make the sysfs attributes definition consistent in the whole file.
> The modification entails change of the function name:
> led_max_brightness_show -> max_brightness_show

I'm not sure whether DEVICE_ATTR() is really deprecated but nevertheless 
this is cleaner.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk

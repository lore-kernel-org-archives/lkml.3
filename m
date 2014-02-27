Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaB0Oda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:33:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56023 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaB0Od3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:33:29 -0500
Message-ID: <530F4CA5.6030502@ti.com>
Date: Thu, 27 Feb 2014 16:33:09 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Lee Jones <lee.jones@linaro.org>
CC: <florian.vaussard@epfl.ch>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/3] mfd: twl6040: Select i2c fast mode as default with
 regmap patch
References: <1393509410-1640-1-git-send-email-peter.ujfalusi@ti.com> <1393509410-1640-2-git-send-email-peter.ujfalusi@ti.com> <530F4A84.9070906@ti.com>
In-Reply-To: <530F4A84.9070906@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 04:24 PM, Nishanth Menon wrote:
> 
> we should ideally have been using highspeed for i2c bus.
> 
> is'nt it better if i2c_check_functionality (and adding required flags
> for func) be used to check the adapter speed and decide this in the
> driver instead of hardcoding the bus speed within TWL6040 -
> considering that 6040 can infact do max high speed as well?

Yeah, I was thinking of something similar. Just did not found the API to get
the speed the i2c bus has been configured to.
I'll check this.


-- 
Péter

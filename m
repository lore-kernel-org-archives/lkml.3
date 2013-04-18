Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968264Ab3DRKwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:52:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39383 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967301Ab3DRKwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:52:10 -0400
Message-ID: <516FD042.5090303@ti.com>
Date: Thu, 18 Apr 2013 16:21:46 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>, <khilman@linaro.org>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sylvain Munaut <tnt@246tNt.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [RFT/PATCH 2/6] driver: serial: mpc52xx_uart: Remove	"uart_console"
 defintion
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com> <1366198467-6757-3-git-send-email-sourav.poddar@ti.com> <20130418105003.GB14500@n2100.arm.linux.org.uk>
In-Reply-To: <20130418105003.GB14500@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,
On Thursday 18 April 2013 04:20 PM, Russell King - ARM Linux wrote:
> On Wed, Apr 17, 2013 at 05:04:23PM +0530, Sourav Poddar wrote:
>> Since "uart_console" definition is now moved to serial core
>> haeder file . Serial drivers need not define them.
> This needs to be part of patch 1.  Having it separate may provoke compiler
> warnings.
Ok. I will fold it in the first patch in my next version.

Thanks,
Sourav

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaBXQH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:07:59 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:41925 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaBXQH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:07:58 -0500
Date: Mon, 24 Feb 2014 16:07:51 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Michael Brunner <mibru@gmx.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Chris Healy <chealy@imsco-us.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Christian Rauch <christian.rauch@kontron.com>
Subject: Re: [PATCH] mfd: Add support for COMe-mBT10, COMe-cBT6 and COMe-cHL6
 to Kontron PLD driver
Message-ID: <20140224160751.GE15847@lee--X1>
References: <20140224085346.4959ff7f@hyperion>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140224085346.4959ff7f@hyperion>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds DMI system IDs for the Kontron modules COMe-mBT10, COMe-cBT6
> and COMe-cHL6 to the Kontron PLD driver. The list of supported products in
> the module description is also updated.
> 
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> Acked-by: Christian Rauch <christian.rauch@kontron.com>
> ---
>  drivers/mfd/Kconfig       |  5 +++++
>  drivers/mfd/kempld-core.c | 24 ++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

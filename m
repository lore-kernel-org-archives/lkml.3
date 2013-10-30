Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab3J3Px1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:53:27 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:1564 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab3J3PxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:53:25 -0400
Date: Wed, 30 Oct 2013 16:53:15 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: <linux@roeck-us.net>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] hwmon: (lm90) add support to handle IRQ
Message-ID: <20131030165315.077703b3@endymion.delvare>
In-Reply-To: <1375856306-14415-3-git-send-email-wni@nvidia.com>
References: <1375856306-14415-1-git-send-email-wni@nvidia.com>
	<1375856306-14415-3-git-send-email-wni@nvidia.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Aug 2013 14:18:25 +0800, Wei Ni wrote:
> When the temperature exceed the limit range value,
> the driver can handle the interrupt.
> 
> Signed-off-by: Wei Ni <wni@nvidia.com>
> ---
>  drivers/hwmon/lm90.c |   23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> (...)

This one looks good now, thanks, with just one minor change I'd do
before committing:

> +			dev_err(dev, "cannot request IRQ: %d\n", client->irq);

The ":" isn't really needed, I'll remove it.

-- 
Jean Delvare

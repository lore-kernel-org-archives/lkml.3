Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265Ab3B1Fvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 00:51:33 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17911 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3B1Fva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 00:51:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 27 Feb 2013 21:45:54 -0800
Message-ID: <512EF012.7080006@nvidia.com>
Date: Thu, 28 Feb 2013 11:20:10 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Ian Lartey <ian@slimlogic.co.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "wim@iguana.be" <wim@iguana.be>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/2] watchdog: add Palmas Watchdog support
References: <1361990168-882-1-git-send-email-ian@slimlogic.co.uk>
In-Reply-To: <1361990168-882-1-git-send-email-ian@slimlogic.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 February 2013 12:06 AM, Ian Lartey wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
>
> Add support for the Palmas watchdog timer which has a timeout configurable
> from 1s to 128s.
>
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> ---
>   drivers/watchdog/palmas_wdt.c |  291 +++++++++++++++++++++++++++++++++++++++++
>   1 files changed, 291 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/watchdog/palmas_wdt.c

patch 1 and 2 can be merge as single patch.

generic comment, we have proper watchdog framework where we can have 
some api for watchdog_ops and register as watchdog_register_device().
Then core parts take care of the all fileops/sysfs interface.
This need not to be develop locally.

You can refer wm831x_wdt.c, wm8350_wdt.c driver for more reference where 
it is really used watchdog framework.


I think you can use the watchdog framework for this.



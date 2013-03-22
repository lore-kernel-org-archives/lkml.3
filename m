Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3CVSqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 14:46:19 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1715 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab3CVSqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 14:46:18 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <514CA6F2.40609@broadcom.com>
Date: Fri, 22 Mar 2013 19:46:10 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Lubomir Rintel" <lkundrak@v3.sk>
cc: linux-kernel@vger.kernel.org, "Stephen Warren" <swarren@wwwdotorg.org>,
        "Wim Van Sebroeck" <wim@iguana.be>,
        linux-rpi-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: Add Broadcom BCM2708 watchdog timer
 driver
References: <1363956907-5644-1-git-send-email-lkundrak@v3.sk>
In-Reply-To: <1363956907-5644-1-git-send-email-lkundrak@v3.sk>
X-WSS-ID: 7D5279DA2U82685387-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 01:55 PM, Lubomir Rintel wrote:
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: linux-rpi-kernel@lists.infradead.org
> Cc: linux-watchdog@vger.kernel.org
> ---
>  arch/arm/configs/bcm2835_defconfig |    4 +
>  drivers/watchdog/Kconfig           |   11 +++
>  drivers/watchdog/Makefile          |    1 +
>  drivers/watchdog/bcm2835_wdt.c     |  158 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 174 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/watchdog/bcm2835_wdt.c

Seems like the subject line of the patch is wrong. Otherwise the commit
message should be a little, tiny bit longer explainer how bcm2708 is
related to bcm2835.

Regards,
Arend



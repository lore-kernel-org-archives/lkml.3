Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbaCDUDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:03:51 -0500
Received: from forward4h.mail.yandex.net ([84.201.186.22]:56650 "EHLO
	forward4h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243AbaCDUDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:33 -0500
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2014 15:03:33 EST
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Alexander Shiyan <shc_work@mail.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>
In-Reply-To: <1393054191-8623-1-git-send-email-shc_work@mail.ru>
References: <1393054191-8623-1-git-send-email-shc_work@mail.ru>
Subject: Re: [PATCH 1/4] w1: Remove excess dependencies on W1 for masters and slaves
MIME-Version: 1.0
Message-Id: <746741393963037@web21h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 04 Mar 2014 23:57:17 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone

22.02.2014, 11:30, "Alexander Shiyan" <shc_work@mail.ru>:
> Configuration for masters and slaves is included only if W1 symbol
> enabled, so no reason to check it once more.
>
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
> šdrivers/w1/masters/Kconfig | 3 +--
> šdrivers/w1/slaves/Kconfig š| 5 -----
> š2 files changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
> index efc7f07..6ffe120 100644
> --- a/drivers/w1/masters/Kconfig
> +++ b/drivers/w1/masters/Kconfig
> @@ -36,13 +36,12 @@ config W1_MASTER_DS2482
>
> šconfig W1_MASTER_MXC
> ššššššššštristate "Freescale MXC 1-wire busmaster"
> - depends on W1 && ARCH_MXC
> + depends on ARCH_MXC

I know nothing about this arch, so while this first patch looks good, I can not say anything about the others :)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaJJFE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 01:04:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38279 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaJJFEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 01:04:55 -0400
Message-ID: <543768F3.6090703@wwwdotorg.org>
Date: Thu, 09 Oct 2014 22:04:51 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Jingchang Lu <jingchang.lu@freescale.com>, gregkh@linuxfoundation.org
CC: arnd@arndb.de, Joseph Lo <josephl@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] serial: of-serial: fix up PM ops on no_console_suspend
References: <1412845852-26157-1-git-send-email-jingchang.lu@freescale.com>
In-Reply-To: <1412845852-26157-1-git-send-email-jingchang.lu@freescale.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 02:10 AM, Jingchang Lu wrote:
> Mandatorily disabling the uart clock will cause register access
> hung on "no_console_suspend". This patch add condition check on
> it and only disable the clock with console_suspend_enabled true.

It would be useful if the email/patch subject line said "V2", and there
was a changelog below.

> Signed-off-by: Joseph Lo <josephl@nvidia.com>

I don't think he did; he just suggested a small fix.

> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
> ---
>  drivers/tty/serial/of_serial.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
...

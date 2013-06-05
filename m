Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab3FEGE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 02:04:57 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:40091 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3FEGEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 02:04:46 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Andreas Mohr <andi@lisas.de>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, OndrejZary <linux@rainbow-software.org>,
        Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] usbnet: improve/fix status interrupt endpoint interval
Date: Wed, 05 Jun 2013 08:06:05 +0200
Message-ID: <7493213.1jnuhRJXML@linux-5eaq.site>
User-Agent: KMail/4.10.2 (Linux/3.7.10-1.11-desktop; KDE/4.10.3; x86_64; ; )
In-Reply-To: <20130604182830.GA13186@rhlx01.hs-esslingen.de>
References: <20130604182830.GA13186@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 20:28:30 Andreas Mohr wrote:
> 
> From 307685fe8e6dfc8181e30167b9c31479332cb22f Mon Sep 17 00:00:00 2001
> From: Andreas Mohr <andim2@users.sourceforge.net>
> Date: Sun, 2 Jun 2013 20:37:05 +0200
> Subject: [PATCH] usbnet: improve/fix status interrupt endpoint interval
>  tweaking.
> 
> - failed to take super-speed into account
> - <= full-speed seems to have wrong value (specified as frames [ms],
>   thus 3 is not suitable to achieve 8ms)
>   Value 8 now managed to reduce powertop wakeups from ~ 540 to ~ 155
> - add detailed docs and question marks about current practice
> ---
>  drivers/net/usb/usbnet.c |   17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> 
> Found this with MCS7830 on a full-speed USB 1.1 port (Inspiron 8000).
> Good to have a rusty notebook with noisy PSU coils, else it would
> have taken a lot longer to nail it ;)
> Tested on -rc4, checkpath.pl:d.
> 
> Signed-off-by: Andreas Mohr <andim2@users.sourceforge.net>
Acked-by: Oliver Neukum <oliver@neukum.org>

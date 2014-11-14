Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161339AbaKNSYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:24:08 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54618 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964931AbaKNSYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:24:07 -0500
Message-ID: <546648A8.1000102@ti.com>
Date: Fri, 14 Nov 2014 23:53:36 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: John Ogness <john.ogness@linutronix.de>, <linux-kernel@vger.kernel.org>
CC: <davem@davemloft.net>, <balbi@ti.com>, <george.cherian@ti.com>,
        <jhovold@gmail.com>, <mpa@pengutronix.de>, <bhutchings@solarflare.com>,
        <zonque@gmail.com>, <tklauser@distanz.ch>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] drivers: net: cpsw: Fix TX_IN_SEL offset
References: <87sihlj11v.fsf@linutronix.de>
In-Reply-To: <87sihlj11v.fsf@linutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2014 08:12 PM, John Ogness wrote:
> The TX_IN_SEL offset for the CPSW_PORT/TX_IN_CTL register was
> incorrect. This caused the Dual MAC mode to never get set when
> it should. It also caused possible unintentional setting of a
> bit in the CPSW_PORT/TX_BLKS_REM register.
> 
> The purpose of setting the Dual MAC mode for this register is to:
> 
>     "... allow packets from both ethernet ports to be written into
>      the FIFO without one port starving the other port."
> 					- AM335x ARM TRM
> 
> Signed-off-by: John Ogness <john.ogness@linutronix.de>

Reviewed-by: Mugunthan V N <mugunthanvnm@ti.com>

Regards
Mugunthan V N

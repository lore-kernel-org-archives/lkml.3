Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbaG2JTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:19:09 -0400
Received: from sym2.noone.org ([178.63.92.236]:36387 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbaG2JTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:19:07 -0400
Date: Tue, 29 Jul 2014 11:18:57 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Seunghun Lee <waydi1@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        Lidza Louina <lidza.louina@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: dgnc: remove commented code
Message-ID: <20140729091857.GB16199@distanz.ch>
References: <1406306941-3053-1-git-send-email-waydi1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406306941-3053-1-git-send-email-waydi1@gmail.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-25 at 18:49:01 +0200, Seunghun Lee <waydi1@gmail.com> wrote:
> This patch removes commented code in dgnc driver.
> 
> CC: Lidza Louina <lidza.louina@gmail.com>
> CC: Mark Hounschell <markh@compro.net>
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
> ---
>  drivers/staging/dgnc/dgnc_cls.c   |    5 +-
>  drivers/staging/dgnc/dgnc_trace.c |  123 -------------------------------------
>  drivers/staging/dgnc/dgnc_trace.h |   10 ---
>  drivers/staging/dgnc/dgnc_tty.c   |   18 ------
>  drivers/staging/dgnc/digi.h       |    1 -
>  5 files changed, 1 insertion(+), 156 deletions(-)
> 
> diff --git a/drivers/staging/dgnc/dgnc_cls.c b/drivers/staging/dgnc/dgnc_cls.c
> index 8e265c2..4b65306 100644
> --- a/drivers/staging/dgnc/dgnc_cls.c
> +++ b/drivers/staging/dgnc/dgnc_cls.c
> @@ -1046,10 +1046,7 @@ static void cls_flush_uart_read(struct channel_t *ch)
>  	 * I believe this is a BUG in this UART.
>  	 * So for now, we will leave the code #ifdef'ed out...
>  	 */

The comment above relates to the deleted code, so it should be updated
accordingly.

> -#if 0
> -	writeb((UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_RCVR),
> -					 &ch->ch_cls_uart->isr_fcr);
> -#endif
> +
>  	udelay(10);
>  }

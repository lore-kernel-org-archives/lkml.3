Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3G2Jcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:32:39 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:45452 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab3G2Jch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:32:37 -0400
Message-ID: <1375090305.1956.49.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH 0/4] msm_serial fixes and improvements
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Date: Mon, 29 Jul 2013 12:31:45 +0300
In-Reply-To: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
References: <1374691051-28544-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Wed, 2013-07-24 at 11:37 -0700, Stephen Boyd wrote:
> Here are a couple fixes and improvements to the msm_serial
> driver. The first two patches fix a bug on UARTDM devices and
> silence sparse warnings. The last two patches improve the baud
> code detection and increase the throughput on UARTDM devices.
> 
> After this it is rather trivial to add support for newer UARTDM
> devices via new compatible fields.
> 
> Stephen Boyd (4):
>   msm_serial: Fix NUL byte output on UARTDM
>   msm_serial: Fix sparse warnings
>   msm_serial: Make baud_code detection more dynamic
>   msm_serial: Send more than 1 character at a time on UARTDM
> 

Thanks, It is working on 8074 based DragonBoard.

Tested-by: Ivan T. Ivanov <iivanov@mm-sol.com>


>  drivers/tty/serial/msm_serial.c | 180 ++++++++++++++++++++--------------------
>  drivers/tty/serial/msm_serial.h |  19 ++---
>  2 files changed, 97 insertions(+), 102 deletions(-)
> 



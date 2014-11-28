Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaK1Oqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:46:34 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38372 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaK1Oqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:46:32 -0500
Message-ID: <54788AC3.9090808@cogentembedded.com>
Date: Fri, 28 Nov 2014 17:46:27 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/17] net2280: Remove restart_dma inline function definition
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com> <1417182662-7405-7-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1417182662-7405-7-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11/28/2014 04:50 PM, Ricardo Ribalda Delgado wrote:

> restart_dma is not used before it is declaration. Therefore we can

    s/it is/its/.

> remove this definition.

    You're removing the declaration, not definition.

> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>   drivers/usb/gadget/udc/net2280.c | 2 --
>   1 file changed, 2 deletions(-)

> diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
> index 0340462..e8c36db 100644
> --- a/drivers/usb/gadget/udc/net2280.c
> +++ b/drivers/usb/gadget/udc/net2280.c
> @@ -1043,8 +1043,6 @@ dma_done(struct net2280_ep *ep,	struct net2280_request *req, u32 dmacount,
>   	done(ep, req, status);
>   }
>
> -static void restart_dma(struct net2280_ep *ep);
> -
>   static void scan_dma_completions(struct net2280_ep *ep)
>   {
>   	/* only look at descriptors that were "naturally" retired,

WBR, Sergei


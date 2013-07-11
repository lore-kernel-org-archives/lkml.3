Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3GKGpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 02:45:25 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39962 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3GKGpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 02:45:24 -0400
Date: Thu, 11 Jul 2013 09:45:19 +0300
From: Aldo Iljazi <neonsync1@gmail.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH] Staging: csr: csr_wifi_router_sef.c: fixed a brace coding
 style issue
Message-ID: <20130711064518.GA10611@gmail.com>
References: <1373058194-7961-1-git-send-email-neonsync1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373058194-7961-1-git-send-email-neonsync1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 12:03:14AM +0300, Aldo Iljazi wrote:
> Fixed a coding style issue.
> 
> Signed-off-by: Aldo Iljazi <neonsync1@gmail.com>
> ---
>  drivers/staging/csr/csr_wifi_router_sef.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/csr/csr_wifi_router_sef.c b/drivers/staging/csr/csr_wifi_router_sef.c
> index 45a10fb..bdb7d3b 100644
> --- a/drivers/staging/csr/csr_wifi_router_sef.c
> +++ b/drivers/staging/csr/csr_wifi_router_sef.c
> @@ -9,8 +9,7 @@
>   *****************************************************************************/
>  #include "csr_wifi_router_sef.h"
>  
> -const CsrWifiRouterStateHandlerType CsrWifiRouterDownstreamStateHandlers[CSR_WIFI_ROUTER_PRIM_DOWNSTREAM_COUNT] =
> -{
> +const CsrWifiRouterStateHandlerType CsrWifiRouterDownstreamStateHandlers[CSR_WIFI_ROUTER_PRIM_DOWNSTREAM_COUNT] = {
>      /* 0x0000 */ CsrWifiRouterMaPacketSubscribeReqHandler,
>      /* 0x0001 */ CsrWifiRouterMaPacketUnsubscribeReqHandler,
>      /* 0x0002 */ CsrWifiRouterMaPacketReqHandler,
> -- 
> 1.7.9.5
> 

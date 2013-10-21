Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3JUFIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 01:08:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35546 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752466Ab3JUFIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 01:08:35 -0400
Message-ID: <5264B6C7.9000206@free-electrons.com>
Date: Mon, 21 Oct 2013 07:08:23 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: divy@chelsio.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] chelsio: remove duplicate defines
References: <1382331307-4962-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1382331307-4962-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2013 06:55 AM, Michael Opdenacker wrote:
> This removes duplicate definitions of S_BUSY, V_BUSY() and F_BUSY
> in drivers/net/ethernet/chelsio/cxgb3/regs.h
Forget this version. There are other duplicates in this file. I'll
submit a new version of this patch.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb3/regs.h | 12 ------------
>  1 file changed, 12 deletions(-)
>
> diff --git a/drivers/net/ethernet/chelsio/cxgb3/regs.h b/drivers/net/ethernet/chelsio/cxgb3/regs.h
> index 6990f6c..b8367ec 100644
> --- a/drivers/net/ethernet/chelsio/cxgb3/regs.h
> +++ b/drivers/net/ethernet/chelsio/cxgb3/regs.h
> @@ -685,10 +685,6 @@
>  #define V_BUSY(x) ((x) << S_BUSY)
>  #define F_BUSY    V_BUSY(1U)
>  
> -#define S_BUSY    31
> -#define V_BUSY(x) ((x) << S_BUSY)
> -#define F_BUSY    V_BUSY(1U)
> -
>  #define A_MC7_EXT_MODE1 0x108
>  
>  #define A_MC7_EXT_MODE2 0x10c
> @@ -749,14 +745,6 @@
>  
>  #define A_MC7_CAL 0x128
>  
> -#define S_BUSY    31
> -#define V_BUSY(x) ((x) << S_BUSY)
> -#define F_BUSY    V_BUSY(1U)
> -
> -#define S_BUSY    31
> -#define V_BUSY(x) ((x) << S_BUSY)
> -#define F_BUSY    V_BUSY(1U)
> -
>  #define S_CAL_FAULT    30
>  #define V_CAL_FAULT(x) ((x) << S_CAL_FAULT)
>  #define F_CAL_FAULT    V_CAL_FAULT(1U)


-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098


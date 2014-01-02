Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaABXd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 18:33:57 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34898 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaABXd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 18:33:56 -0500
Message-ID: <52C5F760.20302@lwfinger.net>
Date: Thu, 02 Jan 2014 17:33:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tim Jester-Pfadt <t.jp@gmx.de>, gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Staging: rtl8188eu: Fixed coding style issues
References: <20140102204640.GA1149@archlinux> <20140102232259.GA4112@archlinux>
In-Reply-To: <20140102232259.GA4112@archlinux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 05:22 PM, Tim Jester-Pfadt wrote:
> Fixed indentation coding style issues on rtw_io.c
>
> Signed-off-by: Tim Jester-Pfadt <t.jp@gmx.de>
> ---
>   drivers/staging/rtl8188eu/core/rtw_io.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
> index 10c9c65..f1b8dfe 100644
> --- a/drivers/staging/rtl8188eu/core/rtw_io.c
> +++ b/drivers/staging/rtl8188eu/core/rtw_io.c
> @@ -205,9 +205,9 @@ void _rtw_read_mem(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
>
>   	_func_enter_;
>   	if (adapter->bDriverStopped || adapter->bSurpriseRemoved) {
> -	     RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
> -		      ("rtw_read_mem:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
> -		      adapter->bDriverStopped, adapter->bSurpriseRemoved));
> +		RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
> +			 ("rtw_read_mem:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
> +			 adapter->bDriverStopped, adapter->bSurpriseRemoved));
>   	     return;
>   	}
>   	_read_mem = pintfhdl->io_ops._read_mem;
> @@ -239,9 +239,9 @@ void _rtw_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
>   	_func_enter_;
>
>   	if (adapter->bDriverStopped || adapter->bSurpriseRemoved) {
> -	     RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
> -		      ("rtw_read_port:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
> -		      adapter->bDriverStopped, adapter->bSurpriseRemoved));
> +		RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
> +			 ("rtw_read_port:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
> +			 adapter->bDriverStopped, adapter->bSurpriseRemoved));
>   	     return;
>   	}

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry



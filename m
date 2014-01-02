Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaABRxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:53:48 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46239 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaABRxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:53:46 -0500
Message-ID: <52C5A7A7.7020903@lwfinger.net>
Date: Thu, 02 Jan 2014 11:53:43 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tim Jester-Pfadt <t.jp@gmx.de>, gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8188eu: Fixed coding style issues
References: <20140102170356.GA29980@archlinux>
In-Reply-To: <20140102170356.GA29980@archlinux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 11:03 AM, Tim Jester-Pfadt wrote:
> Fixed indentation coding style issues on rtw_io.c
>
> Signed-off-by: Tim Jester-Pfadt <t.jp@gmx.de>
> ---
>   drivers/staging/rtl8188eu/core/rtw_io.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
> index 10c9c65..69b408e 100644
> --- a/drivers/staging/rtl8188eu/core/rtw_io.c
> +++ b/drivers/staging/rtl8188eu/core/rtw_io.c
> @@ -205,7 +205,7 @@ void _rtw_read_mem(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
>
>   	_func_enter_;
>   	if (adapter->bDriverStopped || adapter->bSurpriseRemoved) {
> -	     RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
> +		RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
>   		      ("rtw_read_mem:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
>   		      adapter->bDriverStopped, adapter->bSurpriseRemoved));
>   	     return;
> @@ -239,7 +239,7 @@ void _rtw_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
>   	_func_enter_;
>
>   	if (adapter->bDriverStopped || adapter->bSurpriseRemoved) {
> -	     RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
> +		RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
>   		      ("rtw_read_port:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
>   		      adapter->bDriverStopped, adapter->bSurpriseRemoved));
>   	     return;

Did you run checkpatch.pl on this patch? You fixed the indents on the RT_TRACE 
statements, but the alignment of the continuing statements is wrong. That part 
was correct before.

Larry



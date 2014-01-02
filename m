Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaABVhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:37:17 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:42037 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbaABVhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:37:15 -0500
Message-ID: <52C5DC08.6030508@lwfinger.net>
Date: Thu, 02 Jan 2014 15:37:12 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tim Jester-Pfadt <t.jp@gmx.de>, gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: rtl8188eu: Fixed coding style issues
References: <20140102204640.GA1149@archlinux>
In-Reply-To: <20140102204640.GA1149@archlinux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 02:46 PM, Tim Jester-Pfadt wrote:
> Fixed indentation coding style issues on rtw_io.c
>
> Signed-off-by: Tim Jester-Pfadt <t.jp@gmx.de>
> ---
>   drivers/staging/rtl8188eu/core/rtw_io.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
> index 10c9c65..6be6c50 100644
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
> +			("rtw_read_mem:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
> +			adapter->bDriverStopped, adapter->bSurpriseRemoved));

The latest version of checkpatch.pl lists the following:

CHECK: Alignment should match open parenthesis
#87: FILE: drivers/staging/rtl8188eu/core/rtw_io.c:207:
+               RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
+                       ("rtw_read_mem:bDriverStopped(%d) OR bSurpriseRemoved(%d)",

The continuing lines should be indented one more space.

Larry


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972AbaEUEKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 00:10:36 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:37429 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaEUEKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 00:10:35 -0400
MIME-Version: 1.0
In-Reply-To: <5369af4d.8482440a.284c.1d3c@mx.google.com>
References: <5369af4d.8482440a.284c.1d3c@mx.google.com>
Date: Wed, 21 May 2014 09:40:34 +0530
Message-ID: <CAPV97yegNd+MyptVo2J-g+k2hAWsiK-Fmk6i=hNQsavD_xcEew@mail.gmail.com>
Subject: Re: [PATCH 00/13]staging: rtl8188eu: Remove unused functions and variables
From: navin patidar <navin.patidar@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Please merge this patchset, It has been pending for some time.

regards,
navin patidar

On Wed, May 7, 2014 at 9:27 AM,  <navin.patidar@gmail.com> wrote:
> From: navin patidar <navin.patidar@gmail.com>
>
> Following patches remove unused functions, variables and functions with empty
> definition.
>
> navin patidar (13):
>   staging: rtl8188eu: Remove 'semaphore allrxreturnevt' from struct
>     recv_priv
>   staging: rtl8188eu: Remove unused member variables of struct
>     recv_priv
>   staging: rtl8188eu: Remove 'spinlock_t lock' from struct recv_priv
>   staging: rtl8188eu: Remove struct zero_bulkout_context
>   staging: rtl8188eu: Remove function rtw_os_recv_resource_init()
>   staging: rtl8188eu: Remove function rtw_os_recv_resource_free()
>   staging: rtl8188eu: Remove function rtw_hostapd_mlme_rx()
>   staging: rtl8188eu: Remove function rtw_os_recvbuf_resource_free()
>   staging: rtl8188eu: Remove unused inline function recvframe_push()
>   staging: rtl8188eu: Remove unused inline function get_rx_status()
>   staging: rtl8188eu: Remove 'void  *precvbuf' from struct recv_frame
>   staging: rtl8188eu: Remove 'int frame_tag' from struct recv_frame
>   staging: rtl8188eu: Remove 'u8 fragcnt' from struct recv_frame
>
>  drivers/staging/rtl8188eu/core/rtw_mlme_ext.c    |    2 --
>  drivers/staging/rtl8188eu/core/rtw_recv.c        |    8 -----
>  drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c   |    2 +-
>  drivers/staging/rtl8188eu/hal/usb_ops_linux.c    |    1 -
>  drivers/staging/rtl8188eu/include/recv_osdep.h   |    4 ---
>  drivers/staging/rtl8188eu/include/rtw_recv.h     |   36 ----------------------
>  drivers/staging/rtl8188eu/os_dep/recv_linux.c    |   25 ---------------
>  drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c |    7 -----
>  8 files changed, 1 insertion(+), 84 deletions(-)
>
> --
> 1.7.10.4
>

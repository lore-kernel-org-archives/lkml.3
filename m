Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaGITBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:01:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaGITBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:01:20 -0400
Date: Wed, 9 Jul 2014 12:05:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: navin patidar <navin.patidar@gmail.com>
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/48] staging: rtl8188eu: Remove struct evt_priv and its
 uses
Message-ID: <20140709190545.GA14542@kroah.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 10:16:57PM +0530, navin patidar wrote:
> c2h_wk (work_struct) is naver scheduled to handle events,
> so no use of keeping event data.
> And also function rtw_hal_c2h_handler() responsible for handling c2h events,
> is a dummy function.
> 
> Signed-off-by: navin patidar <navin.patidar@gmail.com>
> ---
>  drivers/staging/rtl8188eu/core/rtw_cmd.c      |   86 -------------------------
>  drivers/staging/rtl8188eu/core/rtw_mlme_ext.c |    4 --
>  drivers/staging/rtl8188eu/include/cmd_osdep.h |    1 -
>  drivers/staging/rtl8188eu/include/drv_types.h |    1 -
>  drivers/staging/rtl8188eu/include/rtw_cmd.h   |   14 ----
>  drivers/staging/rtl8188eu/os_dep/os_intfs.c   |    8 ---
>  6 files changed, 114 deletions(-)

This patch doesn't apply either (probably due to me not taking your
previous series.)

So, can you refresh all of your pending patches that I have not applied
yet against my tree, and resend them?

thanks,

greg k-h

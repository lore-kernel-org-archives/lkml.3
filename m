Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161030Ab3CVQgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:36:36 -0400
Received: from void.printf.net ([89.145.121.20]:39075 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161003Ab3CVQgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:36:35 -0400
From: Chris Ball <cjb@laptop.org>
To: <wei_wang@realsil.com.cn>
Cc: <sameo@linux.intel.com>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>
Subject: Re: [PATCH] mmc/host:rtsx: Don't execute power up sequence repeatedly
References: <1362726357-7629-1-git-send-email-wei_wang@realsil.com.cn>
Date: Fri, 22 Mar 2013 12:36:26 -0400
In-Reply-To: <1362726357-7629-1-git-send-email-wei_wang@realsil.com.cn> (wei
	wang's message of "Fri, 8 Mar 2013 15:05:57 +0800")
Message-ID: <87txo3o0hh.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 08 2013, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
>
> For some Realtek's card reader, power up sequence can only be executed
> when power has been turned off fully.
> So rtsx host should not start power up sequence again when set_ios been
> called if the power has been turned on.
>
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
> ---
>  drivers/mmc/host/rtsx_pci_sdmmc.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)

Thanks, pushed to mmc-next for 3.10.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

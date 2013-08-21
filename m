Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab3HUItB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:49:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37401 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3HUIs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:48:58 -0400
Date: Wed, 21 Aug 2013 09:48:42 +0100
From: Lee Jones <lee.jones@linaro.org>
To: wei_wang@realsil.com.cn
Cc: cjb@laptop.org, sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        gregkh@linuxfoundation.org, rogerable@realtek.com
Subject: Re: [PATCH 1/3] mfd:mmc:rtsx: Change default tx phase
Message-ID: <20130821084842.GE29850@lee--X1>
References: <cover.1377049122.git.wei_wang@realsil.com.cn>
 <0dd50ed0bb16afbb47d8de8ba6eb4f9d1c901d45.1377049122.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0dd50ed0bb16afbb47d8de8ba6eb4f9d1c901d45.1377049122.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013, wei_wang@realsil.com.cn wrote:

> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> The default phase can meet most cards' requirement, but it is not the
> optimal one. In some extreme situation, the rx phase point produced by
> the following tuning process will drift quite a distance.
> Before tuning UHS card, this patch will set a more proper initial tx
> phase point, which is calculated from statistic data, and can achieve
> a much better tx signal quality.
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
> ---
>  drivers/mfd/rtl8411.c             |    4 +++
>  drivers/mfd/rts5209.c             |    2 ++
>  drivers/mfd/rts5227.c             |    2 ++
>  drivers/mfd/rts5229.c             |    2 ++
>  drivers/mfd/rts5249.c             |    2 ++
>  drivers/mmc/host/rtsx_pci_sdmmc.c |   58 +++++++++++++++++++++++++++----------
>  include/linux/mfd/rtsx_pci.h      |   15 ++++++++++
>  7 files changed, 69 insertions(+), 16 deletions(-)

MFD parts looks okay to me:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

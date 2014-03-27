Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaC0ILP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 04:11:15 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:45432 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbaC0ILI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 04:11:08 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1395824147.git.micky_ching@realsil.com.cn>
References: <cover.1395824147.git.micky_ching@realsil.com.cn>
Date: Thu, 27 Mar 2014 09:11:07 +0100
Message-ID: <CAPDyKFrdddMjtGKutx1=Czbf6GyVu+TA9cBVT6zYE=HnA3abCg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mmc: rtsx: add new cmd type handle and modify
 error handle
From: Ulf Hansson <ulf.hansson@linaro.org>
To: micky <micky_ching@realsil.com.cn>
Cc: Chris Ball <chris@printf.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Roger <rogerable@realtek.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 March 2014 06:35,  <micky_ching@realsil.com.cn> wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
>
> v2:
> fix checkpatch warning.
> WARNING: Missing a blank line after declarations
>
> v1:
> Add new command type(R1 without CRC) handle, without this
> patch mmc card initialize will be failed.
>
> Using a more careful handle in request timeout, this would
> improve error recover capability. Debug info is printed
> using non DMA mode, this would help print more accurately
> for DMA command failed. Smatch warning was removed.
>
> Micky Ching (2):
>   mmc: rtsx: add R1-no-CRC mmc command type handle
>   mmc: rtsx: modify error handle and remove smatch warnings
>
>  drivers/mmc/host/rtsx_pci_sdmmc.c |  122 +++++++++++++++++++++----------------
>  1 file changed, 68 insertions(+), 54 deletions(-)

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

>
> --
> 1.7.9.5

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaCYKo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 06:44:59 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:52484 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbaCYKo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 06:44:57 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1395625491.git.micky_ching@realsil.com.cn>
References: <cover.1395625491.git.micky_ching@realsil.com.cn>
Date: Tue, 25 Mar 2014 11:44:57 +0100
Message-ID: <CAPDyKFrk-7msEVcYzY5Vc+ZODtMbiCWGAMU7G2oscgN1Ad9URA@mail.gmail.com>
Subject: Re: [PATCH 0/2] mmc: rtsx: add new cmd type handle and modify error handle
From: Ulf Hansson <ulf.hansson@linaro.org>
To: micky_ching@realsil.com.cn
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

On 25 March 2014 10:47,  <micky_ching@realsil.com.cn> wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
>
> Add new command type(R1 without CRC) handle, without this
> patch mmc card initialize will be failed.
>
> Using a more careful handle in request timeout, this would
> improve error recover capability. Debug info is printed
> using non DMA mode, this would help print more accurately
> for DMA command failed. Smatch warning was removed.

Hi Micky,

Seems like this patchset has been around for some time, sorry for the delay.

I don't have any objections to it getting merged, but you need to run
checkpatch of your patches. Patch2 has a warning you should fix.

Kind regards
Ulf Hansson


>
> Micky Ching (2):
>   mmc: rtsx: add R1-no-CRC mmc command type handle
>   mmc: rtsx: modify error handle and remove smatch warnings
>
>  drivers/mmc/host/rtsx_pci_sdmmc.c |  121 ++++++++++++++++++++-----------------
>  1 file changed, 67 insertions(+), 54 deletions(-)
>
> --
> 1.7.9.5

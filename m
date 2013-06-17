Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3FQRUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:20:44 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:50380 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3FQRUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:20:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 00/11] media: davinci: vpif driver cleanup
Date: Mon, 17 Jun 2013 19:20:54 +0200
Message-ID: <2109154.PkSYdnQTas@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patches.

On Monday 17 June 2013 20:50:40 Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch series cleans the VPIF driver, uses devm_* api wherever
> required and uses module_platform_driver() to simplify the code.
> 
> This patch series applies on http://git.linuxtv.org/hverkuil/media_tree.git/
> shortlog/refs/heads/for-v3.11 and is tested on OMAP-L138 EVM.
> 
> Changes for v2:
> 1: Rebased on v3.11 branch of Hans.
> 2: Dropped the patches which removed headers as mentioned by Laurent.
> 
> Changes for v3:
> 1: Splitted the patches logically as mentioned by Laurent.
> 2: Fixed review comments pointed by Laurent.
> 3: Included Ack's.
> 
> Changes for v4:
> 1: Rebased on v3.11 branch of Hans.
> 2: Fixed review comments pointed by Laurent and Sergei.
> 3: Included Ack's.
> 4: Removed unnecessary loop for IRQ resource.

For the whole series,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> Lad, Prabhakar (11):
>   media: davinci: vpif: remove unwanted header mach/hardware.h and sort
>     the includes alphabetically
>   media: davinci: vpif: Convert to devm_* api
>   media: davinci: vpif: remove unnecessary braces around defines
>   media: davinci: vpif_capture: move the freeing of irq and global
>     variables to remove()
>   media: davinci: vpif_capture: use module_platform_driver()
>   media: davinci: vpif_capture: Convert to devm_* api
>   media: davinci: vpif_capture: remove unnecessary loop for IRQ
>     resource
>   media: davinci: vpif_display: move the freeing of irq and global
>     variables to remove()
>   media: davinci: vpif_display: use module_platform_driver()
>   media: davinci: vpif_display: Convert to devm_* api
>   media: davinci: vpif_display: remove unnecessary loop for IRQ
>     resource
> 
>  drivers/media/platform/davinci/vpif.c         |   45 ++++-----------
>  drivers/media/platform/davinci/vpif_capture.c |   76 +++++-----------------
>  drivers/media/platform/davinci/vpif_display.c |   65 +++++----------------
>  3 files changed, 39 insertions(+), 147 deletions(-)

-- 
Regards,

Laurent Pinchart


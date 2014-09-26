Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaIZDBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 23:01:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33717 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbaIZDBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 23:01:34 -0400
Date: Thu, 25 Sep 2014 20:01:26 -0700
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] toshiba_acpi: Rename hci_raw to tci_raw
Message-ID: <20140926030126.GA40523@vmdeb7>
References: <1411518268-2773-1-git-send-email-coproscefalo@gmail.com>
 <1411518268-2773-2-git-send-email-coproscefalo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411518268-2773-2-git-send-email-coproscefalo@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 06:24:25PM -0600, Azael Avalos wrote:
> The function name hci_raw was used before to reflect
> a raw (read/write) call to the Toshiba's Hardware
> Configuration Interface (HCI), however, since the
> introduction of the System Configuration Interface
> (SCI), that "name" no longer applies.
> 
> This patch changes the name of that function to
> tci_raw (for Toshiba Configuration Interface), and
> change the comments about it.

I'm not following the motivation for this change. The HCI clearly still exists,
at least on the platforms this driver was written to support. When/Where was the
"SCI" "introduced" in a way that requires a change here? Was this a change by
Toshiba you are refering to?


> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> ---
>  drivers/platform/x86/toshiba_acpi.c | 40 ++++++++++++++++++-------------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> index edd8f3d..b7030dc 100644
> --- a/drivers/platform/x86/toshiba_acpi.c
> +++ b/drivers/platform/x86/toshiba_acpi.c
> @@ -71,7 +71,7 @@ MODULE_LICENSE("GPL");
>  /* Toshiba ACPI method paths */
>  #define METHOD_VIDEO_OUT	"\\_SB_.VALX.DSSX"
>  
> -/* Toshiba HCI interface definitions
> +/* Toshiba configuration interface definitions
>   *
>   * HCI is Toshiba's "Hardware Control Interface" which is supposed to

I'm not sure this patch is appropriate/necessary, but if so, you missed a spot
here :)

-- 
Darren Hart
Intel Open Source Technology Center

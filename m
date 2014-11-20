Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbaKTIYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:24:43 -0500
Received: from exprod7og129.obsmtp.com ([64.18.2.122]:40553 "EHLO
	exprod7og129.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaKTIYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:24:41 -0500
MIME-Version: 1.0
In-Reply-To: <20141107005034.GA8448@alexpilon.ca>
References: <20141107005034.GA8448@alexpilon.ca>
Date: Thu, 20 Nov 2014 13:54:19 +0530
Message-ID: <CAK=zhgoM=0aN52M8ejf9j7fB509nxOazgeYR9BMCF6PG31VFHw@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpt2sas: Fix spelling.
From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
To: Alex Pilon <alp+linux@alexpilon.ca>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        MPT-FusionLinux.pdl@avagotech.com, trivial@kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider this patch as Acked-by: "Sreekanth Reddy"
<Sreekanth.Reddy@avagotech.com>.

Regards,
Sreekanth.

On Fri, Nov 7, 2014 at 6:20 AM, Alex Pilon <alp+linux@alexpilon.ca> wrote:
> Fix 'ioctl' spelling.
>
> Signed-off-by: Alex Pilon <alp+linux@alexpilon.ca>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_ctl.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.h b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
> index fa0567c..7f842c8 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_ctl.h
> +++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.h
> @@ -224,7 +224,7 @@ struct mpt2_ioctl_eventreport {
>  };
>
>  /**
> - * struct mpt2_ioctl_command - generic mpt firmware passthru ioclt
> + * struct mpt2_ioctl_command - generic mpt firmware passthru ioctl
>   * @hdr - generic header
>   * @timeout - command timeout in seconds. (if zero then use driver default
>   *  value).
> --
> 2.1.3
>

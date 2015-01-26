Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbbAZLTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:19:07 -0500
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:44649 "EHLO
	smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900AbbAZLTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:19:05 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54C622A6.80300@mev.co.uk>
Date: Mon, 26 Jan 2015 11:19:02 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: jitendra kumar khasdev <jkhasdev@gmail.com>, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] Staging: comedi: fix line over 80 characters warning
References: <1422040280-20213-1-git-send-email-jkhasdev@gmail.com> <1422040280-20213-2-git-send-email-jkhasdev@gmail.com>
In-Reply-To: <1422040280-20213-2-git-send-email-jkhasdev@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/15 19:11, jitendra kumar khasdev wrote:
> This is patch to file jr3_pci.h that fix up warning line
> over 80 character which is found by checkpatch tool.
>
> Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
> ---
>   drivers/staging/comedi/drivers/jr3_pci.h | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/jr3_pci.h b/drivers/staging/comedi/drivers/jr3_pci.h
> index 20478ae..356811d 100644
> --- a/drivers/staging/comedi/drivers/jr3_pci.h
> +++ b/drivers/staging/comedi/drivers/jr3_pci.h
> @@ -261,8 +261,9 @@ struct intern_transform {
>   	} link[8];
>   };
>
> -/*  JR3 force/torque sensor data definition. For more information see sensor and */
> -/*  hardware manuals. */
> +/*  JR3 force/torque sensor data definition. For more information see sensor
> + *  and hardware manuals.
> + */

The usual block comment style is like this:

/*
  * Blah blah
  * blah.
  */

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-

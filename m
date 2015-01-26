Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbbAZLUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:20:51 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:35874 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbbAZLUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:20:48 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54C6230D.4040208@mev.co.uk>
Date: Mon, 26 Jan 2015 11:20:45 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: jitendra kumar khasdev <jkhasdev@gmail.com>, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] Staging: comedi: fix line over 80 characters warning
References: <1422040280-20213-1-git-send-email-jkhasdev@gmail.com> <1422040280-20213-3-git-send-email-jkhasdev@gmail.com>
In-Reply-To: <1422040280-20213-3-git-send-email-jkhasdev@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/15 19:11, jitendra kumar khasdev wrote:
> This is patch to file jr3_pci.c that fix up warning line
> over 80 character which is found by checkpatch tool. Made change into signature
> of struct jr3_pci_poll_delay jr3_pci_poll_subdevice function by giving a newline
> so that 80 character line over warning to be reduced.
>
> Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
> ---
>   drivers/staging/comedi/drivers/jr3_pci.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
> index 81fab2d..1de843d 100644
> --- a/drivers/staging/comedi/drivers/jr3_pci.c
> +++ b/drivers/staging/comedi/drivers/jr3_pci.c
> @@ -449,7 +449,8 @@ static int jr3_download_firmware(struct comedi_device *dev,
>   	return 0;
>   }
>
> -static struct jr3_pci_poll_delay jr3_pci_poll_subdevice(struct comedi_subdevice *s)
> +static struct jr3_pci_poll_delay jr3_pci_poll_subdevice(struct comedi_subdevice
> +							*s)

I think it looks better wrapped like this:

static struct jr3_pci_poll_delay
jr3_pci_poll_subdevice(struct comedi_subdevice *s)

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-

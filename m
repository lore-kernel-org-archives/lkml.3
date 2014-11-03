Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaKCKSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:18:16 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:41164 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbaKCKSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:18:14 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54575662.7030403@mev.co.uk>
Date: Mon, 03 Nov 2014 10:18:10 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.1.2
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chase Southwood <chase.southwood@yahoo.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: comedi_bond.c:  Remove unneeded
 #define
References: <1414966324-18285-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1414966324-18285-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/14 22:12, Rickard Strandqvist wrote:
> Remove unneeded #define. This was previously included in a patch set
> two but patchset one was taken by mistake.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/staging/comedi/drivers/comedi_bond.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
> index 5d19861..85b2f4a 100644
> --- a/drivers/staging/comedi/drivers/comedi_bond.c
> +++ b/drivers/staging/comedi/drivers/comedi_bond.c
> @@ -61,8 +61,7 @@ struct bonded_device {
>   };
>
>   struct comedi_bond_private {
> -# define MAX_BOARD_NAME 256
> -	char name[MAX_BOARD_NAME];
> +	char name[256];
>   	struct bonded_device **devs;
>   	unsigned ndevs;
>   	unsigned nchans;
>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-

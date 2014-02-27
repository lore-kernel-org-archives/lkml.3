Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaB0Qvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:51:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18996 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaB0Qvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:51:54 -0500
Date: Thu, 27 Feb 2014 19:47:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Reza Snowdon <rs@mage.me.uk>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        speakup@braille.uwo.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: speakup: buffers: Fixed a return value coding
 style issue.
Message-ID: <20140227164751.GU26722@mwanda>
References: <1393518402-24860-1-git-send-email-rs@mage.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393518402-24860-1-git-send-email-rs@mage.me.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 04:26:42PM +0000, Reza Snowdon wrote:
> Fixed a coding style issue.
> 
> Signed-off-by: Reza Snowdon <rs@mage.me.uk>
> ---
>  drivers/staging/speakup/buffers.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/speakup/buffers.c b/drivers/staging/speakup/buffers.c
> index 382973e..8d7caa7 100644
> --- a/drivers/staging/speakup/buffers.c
> +++ b/drivers/staging/speakup/buffers.c
> @@ -55,7 +55,8 @@ static int synth_buffer_free(void)
>  
>  int synth_buffer_empty(void)
>  {
> -	return (buff_in == buff_out);
> +	int buff_comparison = (buff_in == buff_out);
> +	return buff_comparison;

This isn't simpler than the original code.

Just do:

int synth_buffer_empty(void)
{
	return buff_in == buff_out;
}

regards,
dan carpenter


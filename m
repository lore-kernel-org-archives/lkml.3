Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaFZOUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 10:20:08 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48506 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaFZOUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 10:20:06 -0400
Date: Thu, 26 Jun 2014 15:19:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: ab8500-debugfs.c:  Cleaning up values that are
 never used
Message-ID: <20140626141959.GB19645@lee--X1>
References: <1403790000-11334-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403790000-11334-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014, Rickard Strandqvist wrote:

> Remove variable that are never used
> 
> This was found using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/mfd/ab8500-debugfs.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
> index d1a22aa..d514e36 100644
> --- a/drivers/mfd/ab8500-debugfs.c
> +++ b/drivers/mfd/ab8500-debugfs.c
> @@ -1350,12 +1350,11 @@ static int ab8500_print_all_banks(struct seq_file *s, void *p)
>  {
>  	struct device *dev = s->private;
>  	unsigned int i;
> -	int err;
>  
>  	seq_printf(s, AB8500_NAME_STRING " register values:\n");
>  
>  	for (i = 0; i < AB8500_NUM_BANKS; i++) {
> -		err = seq_printf(s, " bank 0x%02X:\n", i);
> +		seq_printf(s, " bank 0x%02X:\n", i);
>  
>  		ab8500_registers_print(dev, i, s);
>  	}

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

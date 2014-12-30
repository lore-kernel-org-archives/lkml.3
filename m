Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaL3WvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:51:23 -0500
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:35136 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbaL3WvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:51:22 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54A32C60.8000405@mev.co.uk>
Date: Tue, 30 Dec 2014 22:51:12 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Andreas Siegling <andreas.siegling@fau.de>, devel@linuxdriverproject.org
CC: linux-kernel@i4.cs.fau.de, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ebru.akagunduz@gmail.com,
        chase.southwood@gmail.com, rickard_strandqvist@spectrumdigital.se,
        Zhutao Lu <lvzhutao@gmail.com>
Subject: Re: [PATCH 2/3] comedi: checkpatch error/warning: spaces
References: <1419792975-31519-1-git-send-email-andreas.siegling@fau.de> <1419792975-31519-3-git-send-email-andreas.siegling@fau.de>
In-Reply-To: <1419792975-31519-3-git-send-email-andreas.siegling@fau.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/12/14 18:56, Andreas Siegling wrote:
> This patch will fix the following checkpatch errors/warnings in
> drivers/staging/comedi/ which are brought by wrong spacing:
> 	ERROR: trailing whitespace
> 	ERROR: space prohibited before that ',' (ctx:WxW)
> 	WARNING: please, no space before tabs
>
> Signed-off-by: Andreas Siegling <andreas.siegling@fau.de>
> Signed-off-by: Zhutao Lu <lvzhutao@gmail.com>
> ---
>   drivers/staging/comedi/drivers/daqboard2000.c | 2 +-
>   drivers/staging/comedi/drivers/das16m1.c      | 2 +-
>   drivers/staging/comedi/drivers/ni_at_a2150.c  | 2 +-
>   drivers/staging/comedi/drivers/ni_stc.h       | 4 ++--
>   drivers/staging/comedi/drivers/s626.c         | 2 +-
>   5 files changed, 6 insertions(+), 6 deletions(-)

Those should really be split into separate patches, but as for your 
PATCH 1/3 it's not worth fixing up the comments this way as they need 
reformatting anyway.

> diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
> index 69e543a..bff4852 100644
> --- a/drivers/staging/comedi/drivers/ni_at_a2150.c
> +++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
> @@ -108,7 +108,7 @@ TRIG_WAKE_EOS
>   #define   IRQ_LVL_BITS(x)		(((x) & 0xf) << 4)	/*  sets irq level */
>   #define   FIFO_INTR_EN_BIT		0x100	/*  enable fifo interrupts */
>   #define   FIFO_INTR_FHF_BIT		0x200	/*  interrupt fifo half full */
> -#define   DMA_INTR_EN_BIT 		0x800	/*  enable interrupt on dma terminal count */
> +#define   DMA_INTR_EN_BIT		0x800	/*  enable interrupt on dma terminal count */
>   #define   DMA_DEM_EN_BIT	0x1000	/*  enables demand mode dma */
>   #define I8253_BASE_REG		0x14
>   #define I8253_MODE_REG		0x17
> diff --git a/drivers/staging/comedi/drivers/ni_stc.h b/drivers/staging/comedi/drivers/ni_stc.h
> index bd69c3f..bb76fe1 100644
> --- a/drivers/staging/comedi/drivers/ni_stc.h
> +++ b/drivers/staging/comedi/drivers/ni_stc.h
> @@ -166,7 +166,7 @@ enum Interrupt_B_Ack_Bits {
>   #define AI_SCAN_IN_PROG_Pulse			_bit4
>   #define AI_EXTMUX_CLK_Pulse			_bit3
>   #define AI_LOCALMUX_CLK_Pulse			_bit2
> -#define AI_SC_TC_Pulse			 	_bit1
> +#define AI_SC_TC_Pulse				_bit1
>   #define AI_CONVERT_Pulse			_bit0
>
>   #define AO_Command_1_Register		9
> @@ -642,7 +642,7 @@ static unsigned AO_UPDATE_Output_Select(enum ao_update_output_selection
>   #define G_Load_Source_Select		_bit7
>   #define G_Reload_Source_Switching	_bit15
>   #define G_Loading_On_Gate		_bit14
> -#define G_Gate_Polarity 		_bit13
> +#define G_Gate_Polarity			_bit13
>
>   #define G_Counting_Once(a)		(((a)&0x03)<<10)
>   #define G_Stop_Mode(a)			(((a)&0x03)<<5)

Those parts of the patch are okay.

> diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
> index 14932c5..fc497dd 100644
> --- a/drivers/staging/comedi/drivers/s626.c
> +++ b/drivers/staging/comedi/drivers/s626.c
> @@ -118,7 +118,7 @@ static void s626_mc_enable(struct comedi_device *dev,
>   static void s626_mc_disable(struct comedi_device *dev,
>   			    unsigned int cmd, unsigned int reg)
>   {
> -	writel(cmd << 16 , dev->mmio + reg);
> +	writel(cmd << 16, dev->mmio + reg);
>   	mmiowb();
>   }

That part of the patch has also been tackled in a separate patch by 
jitendra kumar khasdev.  Your patch predates it, but jitendra's patch is 
split better.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-

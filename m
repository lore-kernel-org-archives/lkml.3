Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaBQNQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:16:43 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:39667 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbaBQNQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:16:42 -0500
Message-ID: <53020BB5.70308@mev.co.uk>
Date: Mon, 17 Feb 2014 13:16:37 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Staging: comedi: addi-data: cleanup comments in hwdrv_apci035.c
References: <1392540006-25972-1-git-send-email-chase.southwood@yahoo.com> <1392540069-26019-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1392540069-26019-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-16 08:41, Chase Southwood wrote:
> This patch for hwdrv_apci035.c aligns comment blocks and makes indentation
> of comments consistent.  Removed all "spaces before tabs" in comment
> indentation as well.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>   .../comedi/drivers/addi-data/hwdrv_apci035.c       | 140 ++++++++++-----------
>   1 file changed, 70 insertions(+), 70 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> index 584a1d5..90d5801 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> @@ -188,17 +188,17 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
>   	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
>   	ui_Command = 0;
>   	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
> -/************************/
> -/* Set the reload value */
> -/************************/
> +	/************************/
> +	/* Set the reload value */
> +	/************************/
>   	outl(data[3], devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 4);
> -/*********************/
> -/* Set the time unit */
> -/*********************/
> +	/*********************/
> +	/* Set the time unit */
> +	/*********************/
>   	outl(data[2], devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 8);
>   	if (data[0] == ADDIDATA_TIMER) {
>
> -		 /******************************/
> +		/******************************/
>   		/* Set the mode :             */
>   		/* - Disable the hardware     */
>   		/* - Disable the counter mode */
> @@ -206,7 +206,7 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
>   		/* - Disable the reset        */
>   		/* - Enable the timer mode    */
>   		/* - Set the timer mode       */
> -		 /******************************/
> +		/******************************/
>
>   		ui_Command =
>   			(ui_Command & 0xFFF719E2UL) | ui_Mode << 13UL | 0x10UL;
> @@ -215,14 +215,14 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
>   	else {
>   		if (data[0] == ADDIDATA_WATCHDOG) {
>
> -		 /******************************/
> +			/******************************/
>   			/* Set the mode :             */
>   			/* - Disable the hardware     */
>   			/* - Disable the counter mode */
>   			/* - Disable the warning      */
>   			/* - Disable the reset        */
>   			/* - Disable the timer mode   */
> -		 /******************************/
> +			/******************************/
>
>   			ui_Command = ui_Command & 0xFFF819E2UL;
>
> @@ -234,73 +234,73 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
>   	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
>   	ui_Command = 0;
>   	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
> -/********************************/
> -/* Disable the hardware trigger */
> -/********************************/
> +	/********************************/
> +	/* Disable the hardware trigger */
> +	/********************************/
>   	ui_Command = ui_Command & 0xFFFFF89FUL;
>   	if (data[4] == ADDIDATA_ENABLE) {
> -    /**********************************/
> +		/**********************************/
>   		/* Set the hardware trigger level */
> -    /**********************************/
> +		/**********************************/
>   		ui_Command = ui_Command | (data[5] << 5);
>   	}
>   	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
>   	ui_Command = 0;
>   	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
> -/*****************************/
> -/* Disable the hardware gate */
> -/*****************************/
> +	/*****************************/
> +	/* Disable the hardware gate */
> +	/*****************************/
>   	ui_Command = ui_Command & 0xFFFFF87FUL;
>   	if (data[6] == ADDIDATA_ENABLE) {
> -/*******************************/
> -/* Set the hardware gate level */
> -/*******************************/
> +		/*******************************/
> +		/* Set the hardware gate level */
> +		/*******************************/
>   		ui_Command = ui_Command | (data[7] << 7);
>   	}
>   	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
>   	ui_Command = 0;
>   	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
> -/*******************************/
> -/* Disable the hardware output */
> -/*******************************/
> +	/*******************************/
> +	/* Disable the hardware output */
> +	/*******************************/
>   	ui_Command = ui_Command & 0xFFFFF9FBUL;
> -/*********************************/
> -/* Set the hardware output level */
> -/*********************************/
> +	/*********************************/
> +	/* Set the hardware output level */
> +	/*********************************/
>   	ui_Command = ui_Command | (data[8] << 2);
>   	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
>   	if (data[9] == ADDIDATA_ENABLE) {
> -   /************************/
> +		/************************/
>   		/* Set the reload value */
> -   /************************/
> +		/************************/
>   		outl(data[11],
>   			devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 24);
> -   /**********************/
> +		/**********************/
>   		/* Set the time unite */
> -   /**********************/
> +		/**********************/
>   		outl(data[10],
>   			devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 28);
>   	}
>
>   	ui_Command = 0;
>   	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
> - /*******************************/
> +	/*******************************/
>   	/* Disable the hardware output */
> - /*******************************/
> +	/*******************************/
>   	ui_Command = ui_Command & 0xFFFFF9F7UL;
> -   /*********************************/
> +	/*********************************/
>   	/* Set the hardware output level */
> -   /*********************************/
> +	/*********************************/
>   	ui_Command = ui_Command | (data[12] << 3);
>   	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
> - /*************************************/
> - /**  Enable the watchdog interrupt  **/
> - /*************************************/
> +	/*************************************/
> +	/**  Enable the watchdog interrupt  **/
> +	/*************************************/
>   	ui_Command = 0;
>   	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
> -/*******************************/
> -/* Set the interrupt selection */
> -/*******************************/
> +	/*******************************/
> +	/* Set the interrupt selection */
> +	/*******************************/
>   	ui_Status = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 16);
>
>   	ui_Command = (ui_Command & 0xFFFFF9FDUL) | (data[13] << 1);
> @@ -348,9 +348,9 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
>   	if (data[0] == 1) {
>   		ui_Command =
>   			inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
> -	 /**********************/
> +		/**********************/
>   		/* Start the hardware */
> -	 /**********************/
> +		/**********************/
>   		ui_Command = (ui_Command & 0xFFFFF9FFUL) | 0x1UL;
>   		outl(ui_Command,
>   			devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
> @@ -358,9 +358,9 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
>   	if (data[0] == 2) {
>   		ui_Command =
>   			inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
> -	 /***************************/
> +		/***************************/
>   		/* Set the trigger command */
> -	 /***************************/
> +		/***************************/
>   		ui_Command = (ui_Command & 0xFFFFF9FFUL) | 0x200UL;
>   		outl(ui_Command,
>   			devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
> @@ -369,10 +369,10 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
>   	if (data[0] == 0) {
>   		/* Stop The Watchdog */
>   		ui_Command = 0;
> -/*
> -* ui_Command = inl(devpriv->iobase+((i_WatchdogNbr-1)*32)+12);
> -* ui_Command = ui_Command & 0xFFFFF9FEUL;
> -*/
> +		/*
> +		* ui_Command = inl(devpriv->iobase+((i_WatchdogNbr-1)*32)+12);
> +		* ui_Command = ui_Command & 0xFFFFF9FEUL;
> +		*/
>   		outl(ui_Command,
>   			devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
>   	}			/*   if (data[1]==0) */
> @@ -525,9 +525,9 @@ static int i_APCI035_ConfigAnalogInput(struct comedi_device *dev,
>   	devpriv->tsk_Current = current;
>   	outl(0x200 | 0, devpriv->iobase + 128 + 0x4);
>   	outl(0, devpriv->iobase + 128 + 0);
> -/********************************/
> -/* Initialise the warning value */
> -/********************************/
> +	/********************************/
> +	/* Initialise the warning value */
> +	/********************************/
>   	outl(0x300 | 0, devpriv->iobase + 128 + 0x4);
>   	outl((data[0] << 8), devpriv->iobase + 128 + 0);
>   	outl(0x200000UL, devpriv->iobase + 128 + 12);
> @@ -564,18 +564,18 @@ static int i_APCI035_ReadAnalogInput(struct comedi_device *dev,
>   	struct addi_private *devpriv = dev->private;
>   	unsigned int ui_CommandRegister = 0;
>
> -/******************/
> -/*  Set the start */
> -/******************/
> +	/******************/
> +	/*  Set the start */
> +	/******************/
>   	ui_CommandRegister = 0x80000;
> - /******************************/
> +	/******************************/
>   	/* Write the command register */
> - /******************************/
> +	/******************************/
>   	outl(ui_CommandRegister, devpriv->iobase + 128 + 8);
>
> -/***************************************/
> -/* Read the digital value of the input */
> -/***************************************/
> +	/***************************************/
> +	/* Read the digital value of the input */
> +	/***************************************/
>   	data[0] = inl(devpriv->iobase + 128 + 28);
>   	return insn->n;
>   }
> @@ -640,32 +640,32 @@ static void v_APCI035_Interrupt(int irq, void *d)
>   		i_WatchdogNbr = i_Flag;
>   		i_Flag = i_Flag + 1;
>   	}
> -  /**************************************/
> +	/**************************************/
>   	/* Read the interrupt status register of temperature Warning */
> -  /**************************************/
> +	/**************************************/
>   	ui_StatusRegister1 = inl(devpriv->iobase + 128 + 16);
> -  /**************************************/
> +	/**************************************/
>   	/* Read the interrupt status register for Watchdog/timer */
> -   /**************************************/
> +	/**************************************/
>
>   	ui_StatusRegister2 =
>   		inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 20);
>
>   	/* Test if warning relay interrupt */
>   	if ((((ui_StatusRegister1) & 0x8) == 0x8)) {
> -	/**********************************/
> +		/**********************************/
>   		/* Disable the temperature warning */
> -	/**********************************/
> +		/**********************************/
>   		ui_ReadCommand = inl(devpriv->iobase + 128 + 12);
>   		ui_ReadCommand = ui_ReadCommand & 0xFFDF0000UL;
>   		outl(ui_ReadCommand, devpriv->iobase + 128 + 12);
> -      /***************************/
> +		/***************************/
>   		/* Read the channel number */
> -      /***************************/
> +		/***************************/
>   		ui_ChannelNumber = inl(devpriv->iobase + 128 + 60);
> -	/**************************************/
> +		/**************************************/
>   		/* Read the digital temperature value */
> -	/**************************************/
> +		/**************************************/
>   		ui_DigitalTemperature = inl(devpriv->iobase + 128 + 60);
>   		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
>   	}			/* if (((ui_StatusRegister1 & 0x8) == 0x8)) */
>

Looks good.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-

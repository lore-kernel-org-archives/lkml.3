Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620AbaLCAh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:37:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933561AbaLCAh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:37:57 -0500
Date: Tue, 2 Dec 2014 16:37:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Anjana Sasindran <anjanasasindran123@gmail.com>
Cc: soren.brinkmann@xilinx.com, laurent.pinchart@ideasonboard.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]
 staging:drivers:staging:clocking-wizard:clk-xlnx-clock-wizard.c: Added a
 line after declaration
Message-ID: <20141203003757.GA3253@kroah.com>
References: <1417265730-5489-1-git-send-email-anjanasasindran123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417265730-5489-1-git-send-email-anjanasasindran123@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 06:25:30PM +0530, Anjana Sasindran wrote:
> This patch fix the checkpatch.pl warning
> 
> WARNING:Missing a blank line after declaration
> 
> Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
> ---
>  drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
> index 7202d8e..5fa813d 100644
> --- a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
> +++ b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
> @@ -234,6 +234,7 @@ static int clk_wzrd_probe(struct platform_device *pdev)
>  	/* register div per output */
>  	for (i = WZRD_NUM_OUTPUTS - 1; i >= 0 ; i--) {
>  		const char *clkout_name;
> +		
>  		if (of_property_read_string_index(np, "clock-output-names", i,
>  						  &clkout_name)) {
>  			dev_err(&pdev->dev,
> -- 
> 1.9.1

ALWAYS run your patches through checkpatch.pl so you don't get angry
emails from maintainers telling you that you added a warning with a
patch you were trying to get applied to remove a warning, making this a
pointless exercise :(

greg k-h

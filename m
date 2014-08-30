Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaH3UNA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 16:13:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaH3UM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 16:12:59 -0400
Date: Sat, 30 Aug 2014 13:12:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Plummer <plummer574@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: nokia_h4p: nokia_fw: remove extra return
Message-ID: <20140830201258.GA8674@kroah.com>
References: <1409422491-6325-1-git-send-email-plummer574@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409422491-6325-1-git-send-email-plummer574@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 07:14:51PM +0100, Andrew Plummer wrote:
> Remove empty return at end of function.
> 
> Signed-off-by: Andrew Plummer <plummer574@gmail.com>
> ---
>  drivers/staging/nokia_h4p/nokia_fw.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/staging/nokia_h4p/nokia_fw.c b/drivers/staging/nokia_h4p/nokia_fw.c
> index 14ba219..18953ae 100644
> --- a/drivers/staging/nokia_h4p/nokia_fw.c
> +++ b/drivers/staging/nokia_h4p/nokia_fw.c
> @@ -197,8 +197,6 @@ void hci_h4p_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb)
>  		dev_err(info->dev, "Don't know how to parse fw event\n");
>  		info->fw_error = -EINVAL;
>  	}
> -
> -	return;
>  }
>  
>  MODULE_FIRMWARE(FW_NAME_TI1271_PRELE);

Sorry, but I just deleted this driver from my tree, so I can't take a
patch for the code :(

greg k-h

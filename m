Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3FFVWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:22:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42185 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3FFVWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:22:24 -0400
Date: Fri, 7 Jun 2013 00:14:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Schilling <of82ecuq@cip.cs.fau.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Kurt Kanzenbach <shifty91@gmail.com>, linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: Re: [PATCH 3/6] keucr: migrate printk to dev_dbg/info/warn/err
Message-ID: <20130606211422.GD28112@mwanda>
References: <20130605094517.GS28112@mwanda>
 <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
 <1370535050-7167-4-git-send-email-of82ecuq@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370535050-7167-4-git-send-email-of82ecuq@cip.cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 06:10:47PM +0200, Johannes Schilling wrote:
> @@ -321,7 +320,7 @@ int ENE_Write_Data(struct us_data *us, void *buf, unsigned int length)
>  /*
>   * usb_stor_print_cmd():
>   */
> -void usb_stor_print_cmd(struct scsi_cmnd *srb)
> +void usb_stor_print_cmd(struct us_data *us,struct scsi_cmnd *srb)
                                             ^^
Missing space.  Run checkpatch.pl over your patch to find these.
This can be fixed in a later patch I think.

>  {
>  	PBYTE	Cdb = srb->cmnd;
>  	DWORD	cmd = Cdb[0];

regards,
dan carpenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaHGUYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 16:24:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaHGUYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 16:24:08 -0400
Date: Thu, 7 Aug 2014 13:24:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Miguel Oliveira <cmroliv@gmail.com>, gulsah.1004@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nokia_h4: use more consistent name for
 intermediate object
Message-ID: <20140807202407.GC6060@kroah.com>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
 <20140530123023.GA10549@amd.pavel.ucw.cz>
 <20140530155959.GA10682@kroah.com>
 <201405301815.10811@pali>
 <20140530163604.GA11943@kroah.com>
 <DB71A450-EF1D-479F-9111-A36FF8EA89B2@holtmann.org>
 <20140806213055.GA26046@amd.pavel.ucw.cz>
 <20140807002532.GB23406@kroah.com>
 <20140807081328.GB24700@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807081328.GB24700@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 10:13:29AM +0200, Pavel Machek wrote:
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/drivers/staging/nokia_h4p/Makefile b/drivers/staging/nokia_h4p/Makefile
> index 9625db4..daffe3c 100644
> --- a/drivers/staging/nokia_h4p/Makefile
> +++ b/drivers/staging/nokia_h4p/Makefile
> @@ -1,6 +1,6 @@
>  
> -obj-$(CONFIG_BT_NOKIA_H4P)		+= btnokia_h4p.o
> -btnokia_h4p-objs := nokia_core.o nokia_fw.o nokia_uart.o nokia_fw-csr.o \
> +obj-$(CONFIG_BT_NOKIA_H4P)		+= hci_h4p.o
> +hci_h4p-objs := nokia_core.o nokia_fw.o nokia_uart.o nokia_fw-csr.o \
>  		nokia_fw-bcm.o nokia_fw-ti1273.o
>  
>  ccflags-y += -D__CHECK_ENDIAN__

You just changed the kernel module name, did you really mean to do that?

Why?

It's not an "intermediate" object here, it's a .ko file, right?

greg k-h

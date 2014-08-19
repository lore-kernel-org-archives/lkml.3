Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaHSFgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 01:36:17 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:51626 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaHSFgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 01:36:14 -0400
MIME-Version: 1.0
In-Reply-To: <53F1F0D1.6070102@suse.cz>
References: <1407242145-3132-1-git-send-email-sudipm.mukherjee@gmail.com>
	<53F1F0D1.6070102@suse.cz>
Date: Tue, 19 Aug 2014 11:06:13 +0530
Message-ID: <CADVatmOB5csJ9inhYiBMnU96CrbMQN+57nsEsrwizAzOdkJO8w@mail.gmail.com>
Subject: Re: [PATCH] tty: serial: serial_core.c: printk replacement
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Hi, that will not work either, as there is put_device(tty_dev) before
> you use tty_dev.
>
> --
> js
> suse labs
>
Hi,
i missed that. I put my test message to test tty_dev immediately after
tty_dev was initialized and so never got the error when the port was
suspended.
Will change it to pr_err and resend the patch for you to review.

Thanks
Sudip

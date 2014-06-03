Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbaFCU3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:29:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaFCU3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:29:39 -0400
Date: Tue, 3 Jun 2014 13:33:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net
Subject: Re: [PATCH] tty: serial: msm: Fix section mismatch warning
Message-ID: <20140603203318.GB6582@kroah.com>
References: <1401826402-1079-1-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401826402-1079-1-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 03:13:22PM -0500, Kumar Gala wrote:
> WARNING: drivers/tty/built-in.o(.data+0x3544): Section mismatch in
> reference from the variable msm_platform_driver to the function
> .init.text:msm_serial_probe()
> The variable msm_platform_driver references
> the function __init msm_serial_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Where is this mismatch showing up at?  3.15-rc8, 3.16-rc1?  Somewhere
older or else?

thanks,

greg k-h

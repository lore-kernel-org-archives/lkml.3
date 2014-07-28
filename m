Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaG1PVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:21:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaG1PVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:21:41 -0400
Date: Mon, 28 Jul 2014 08:21:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: jslaby@suse.cz, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: serial: serial_core.c: printk replacement
Message-ID: <20140728152111.GA13149@kroah.com>
References: <1406559481-14084-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406559481-14084-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 08:28:01PM +0530, Sudip Mukherjee wrote:
> printk replaced with corresponding pr_* 
> fixed two broken user-visible strings used by the printk

Can you change to use dev_err() instead?  That would help identify the
device and driver causing this problem better.

thanks,

greg k-h

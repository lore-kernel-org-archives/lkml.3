Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaI2Q7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:59:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaI2Q7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:59:39 -0400
Date: Mon, 29 Sep 2014 12:58:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>,
        Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        Robert Elliott <elliott@hp.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 29/38] Introduce dev_printk_string() and
 dev_printk_header()
Message-ID: <20140929165843.GA13163@kroah.com>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
 <1411991947-130166-30-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411991947-130166-30-git-send-email-hare@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 01:58:58PM +0200, Hannes Reinecke wrote:
> Introducing dev_printk_string() and dev_printk_header() to allow
> using an external buffer for printing via dev_printk().
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: LKML <linux-kernel@vger.kernel.org>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/base/core.c    | 24 ++++++++++++++++++++++++
>  include/linux/device.h | 12 ++++++++++++
>  2 files changed, 36 insertions(+)

I don't understand, what are you trying to do with this?  I don't see
any follow-on patches that use this, nor can I find a 00/38 patch for
this series...

thanks,

greg k-h

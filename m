Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaLQRq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:46:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaLQRq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:46:57 -0500
Date: Wed, 17 Dec 2014 09:46:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Hariharan Rangasamy <hariharanrangasamy@gmail.com>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging : lustre : replaced seq_printf() with seq_puts
 and changed include statement
Message-ID: <20141217174656.GA25475@kroah.com>
References: <1418837681-7555-1-git-send-email-hariharanrangasamy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418837681-7555-1-git-send-email-hariharanrangasamy@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 11:04:41PM +0530, Hariharan Rangasamy wrote:
> Used seq_puts instead of seq_printf()
> Used #include <linux/statfs.h> instead of #include <asm/statfs.h>

That's two different things, which means two different patches are
needed.  Please only do one-thing-per-patch.

thanks,

greg k-h

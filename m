Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab3LHN7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 08:59:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3LHN7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 08:59:30 -0500
Date: Sun, 8 Dec 2013 06:01:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "ethan.zhao" <ethan.kernel@gmail.com>
Cc: konrad.wilk@oracle.com, raghavendra.kt@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/debugfs: Check debugfs initialization before using it
Message-ID: <20131208140100.GA22793@kroah.com>
References: <1386502262-1163-1-git-send-email-ethan.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386502262-1163-1-git-send-email-ethan.kernel@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 08, 2013 at 07:31:02PM +0800, ethan.zhao wrote:
> Should check debugfs initialization with debugfs_initialized() before using it,
> Because if it isn't initialized, the return value of fake debugfs_create_dir() etc
> functions would be ERR_PTR(-ENODEV), checking with NULL will not work.

So?  It should "just work" without this check, right?  What happens if
your patch isn't applied and debugfs isn't enabled?

greg k-h

> Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>

Please put your "real" name here, not one with a '.' in it.

thanks,

greg k-h

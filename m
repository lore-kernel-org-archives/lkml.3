Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab3KLHct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:32:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab3KLHci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:32:38 -0500
Date: Mon, 11 Nov 2013 16:28:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Aldo Iljazi <mail@aldo.io>
Cc: marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: ft1000: boot.h: fixed a few styling issues
Message-ID: <20131112002831.GA12851@kroah.com>
References: <1383567322-22879-1-git-send-email-mail@aldo.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383567322-22879-1-git-send-email-mail@aldo.io>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 02:15:22PM +0200, Aldo Iljazi wrote:
> Fixed the following styling issues:
> 
> Line 30:
> Removed space before open square bracket '['
> 
> Lines 31 to 155:
> Moved the commas that were in the start of the lines, to the end of the lines.
> Inserted spaces after the commas.
> Inserted a one tab indentation to each line.
> 
> Signed-off-by: Aldo Iljazi <mail@aldo.io>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

I've applied this to the 'opw-next' branch of the staging.git tree for
now, which will be merged into the staging-next branch when 3.13-rc1 is
out.  Same for your other ft1000 coding style cleanup.

thanks,

greg k-h

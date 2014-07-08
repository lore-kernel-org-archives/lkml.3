Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaGHXSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:18:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaGHXSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:18:54 -0400
Date: Tue, 8 Jul 2014 16:23:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pawel Lebioda <pawel.lebioda89@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: bcm: add missing blank lines after declarations
Message-ID: <20140708232319.GA32703@kroah.com>
References: <20140704203024.GA11946@ThinkPad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140704203024.GA11946@ThinkPad>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 10:30:27PM +0200, Pawel Lebioda wrote:
> This patch fixes almost all 'missing blank line after declaration'
> warnings reported by checkpatch.pl for drivers/staging/bcm.
> 
> Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
> Reviewed-by: Matthias Beyer <mail@beyermatthias.de>

This patch no longer applies due to other changes in this file by other
developers.  Can you refresh it against my latest staging-next branch of
the staging.git tree and resend?

thanks,

greg k-h

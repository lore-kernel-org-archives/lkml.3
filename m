Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3GHQwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:52:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3GHQwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:52:05 -0400
Date: Mon, 8 Jul 2013 09:52:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Aldo Iljazi <neonsync1@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: cxt1e1: ossiRelease.c: fixed a coding style
 issue.
Message-ID: <20130708165204.GA13246@kroah.com>
References: <1373301617-19688-1-git-send-email-neonsync1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373301617-19688-1-git-send-email-neonsync1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 07:40:17PM +0300, Aldo Iljazi wrote:
> Fixed a coding style issue, specifically checkpatch.pl complain:
> ossiRelease.c:27: WARNING: line over 80 characters

And it's wrong, this fix is not the correct way to do this.

I'd recommend just removing it entirely, as it doesn't make much sense
anymore now that the driver is in the kernel tree.

thanks,

greg k-h

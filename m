Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaBOTSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 14:18:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbaBOTSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 14:18:11 -0500
Date: Sat, 15 Feb 2014 11:19:32 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 01/12] misc: vexpress-syscfg: Add udelay-based delay
Message-ID: <20140215191932.GA2280@kroah.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
 <1392138636-29240-2-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392138636-29240-2-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 05:10:25PM +0000, Pawel Moll wrote:
> It is normally preferable to yield the task
> waiting for syscfg operations (that can take
> up to dozens of milliseconds), but when the
> system is shutting down it may not be possible.

Really?  What happens at shutdown that prevents things from being
scheduled?  Why would you want to busy-loop instead at this point in
time?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbbAZWUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 17:20:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbbAZWUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 17:20:48 -0500
Date: Mon, 26 Jan 2015 14:20:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 3.14 40/98] clk: Really fix deadlock with mmap_sem
Message-ID: <20150126222047.GA7540@kroah.com>
References: <20150125180712.859646324@linuxfoundation.org>
 <20150125180714.619587755@linuxfoundation.org>
 <20150126124646.GC2413@charon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126124646.GC2413@charon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 12:46:46PM +0000, Luis Henriques wrote:
> On Sun, Jan 25, 2015 at 10:06:58AM -0800, Greg Kroah-Hartman wrote:
> > 3.14-stable review patch.  If anyone has any objections, please let me know.
> > 
> 
> This patch was tagged for stable 3.18 only.  Also, since commit
> 6314b6796e3c doesn't seem to be in 3.14, I believe shouldn't be in
> this stable kernel.

Nice catch, thanks, I'll go drop it.

greg k-h

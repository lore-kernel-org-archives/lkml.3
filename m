Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab3ETS52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 14:57:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab3ETS50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 14:57:26 -0400
Date: Mon, 20 May 2013 11:57:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <joshc@eso.teric.us>,
        Mike Turquette <mturquette@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 1/5] tty: xuartps: Remove suspend/resume functions
Message-ID: <20130520185725.GA21134@kroah.com>
References: <1368467199-8702-1-git-send-email-soren.brinkmann@xilinx.com>
 <1368467199-8702-2-git-send-email-soren.brinkmann@xilinx.com>
 <51961E02.9020501@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51961E02.9020501@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 02:09:38PM +0200, Michal Simek wrote:
> Hi Greg,
> 
> can you please add this patch to your tree?
> It is unrelated to clk changes which Soren sent.

Ok, will do.

greg k-h

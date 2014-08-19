Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaHSMlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:41:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaHSMlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:41:51 -0400
Date: Tue, 19 Aug 2014 07:41:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yannis Damigos <giannis.damigos@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Fix some code style issues
Message-ID: <20140819124112.GB7791@kroah.com>
References: <1408449431-28224-1-git-send-email-giannis.damigos@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408449431-28224-1-git-send-email-giannis.damigos@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 02:57:11PM +0300, Yannis Damigos wrote:
> Signed-off-by: Yannis Damigos <giannis.damigos@gmail.com>

Your subject: line needs a lot of work.  What part of the kernel are you
changing?

Then you need some description in the body of the changelog saying _why_
you made this change, and what you changed.

Please be more descriptive.

thanks,

greg k-h

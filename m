Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbaGVTXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:23:33 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39978 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaGVTXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:23:32 -0400
Date: Tue, 22 Jul 2014 12:23:28 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Michael Grzeschik <mgr@pengutronix.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATH v2] mxc_nand: use our own read_page function
Message-ID: <20140722192328.GC28323@ld-irv-0074>
References: <1403815368-29469-2-git-send-email-m.grzeschik@pengutronix.de>
 <1403865524-25061-1-git-send-email-m.grzeschik@pengutronix.de>
 <20140714191947.GP7537@ld-irv-0074>
 <20140722100954.GA29623@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722100954.GA29623@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Tue, Jul 22, 2014 at 12:09:54PM +0200, Michael Grzeschik wrote:
> I think your hints all make sense. I was poking around with the
> functions we have and need to asign. Unfortunetly I ran into no clear
> picture to fix it the correct way and came up with this hacky patch.

Your patch is close, so it's not completely a hack. And the various
override functions can be difficult to follow. You can ping back here if
you have questions still.

Regards,
Brian

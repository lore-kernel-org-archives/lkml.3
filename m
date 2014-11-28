Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaK1TQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 14:16:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaK1TQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 14:16:29 -0500
Date: Fri, 28 Nov 2014 11:15:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        joshc@codeaurora.org, johannes.thumshirn@men.de,
        kheitke@codeaurora.org, laurent.pinchart+renesas@ideasonboard.com,
        geert+renesas@glider.be, horms+renesas@verge.net.au,
        damm@opensource.se, tomi.valkeinen@ti.com, mbohan@codeaurora.org,
        michal.simek@xilinx.com, pawel.moll@arm.com, Andrew.Thoelke@arm.com
Subject: Re: [RFC PATCH 1/3] Add generic TrustZone driver
Message-ID: <20141128191507.GA7804@kroah.com>
References: <1417187016-7731-1-git-send-email-javier@javigon.com>
 <1417187016-7731-2-git-send-email-javier@javigon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417187016-7731-2-git-send-email-javier@javigon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 04:03:34PM +0100, Javier González wrote:
> From: Javier Gonzalez <javier@javigon.com>

Any reason you sent this twice?

And your code is full of FIXMEs, which implies that you aren't even
happy with the code, so why would we want to review it as-is now?

Please come up with a design, and implementation, that you feel
comfortable with before asking others to do work to review your broken
implementation.

> +static void trustzone_dev_release(struct device *dev)
> +{
> +	/* FIXME: You need to fix all this crap... */

Yes you do, why you are asking others to do your work is beyond my
comprehension...

greg k-h

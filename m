Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab3AXH1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 02:27:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33992 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab3AXH1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 02:27:32 -0500
Date: Thu, 24 Jan 2013 08:27:24 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: khali@linux-fr.org, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: i2c-nforce2: fix coding style issues
Message-ID: <20130124072723.GI8364@nekote.pengutronix.de>
References: <1357826862-4975-1-git-send-email-laurent.navet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357826862-4975-1-git-send-email-laurent.navet@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 03:07:42PM +0100, Laurent Navet wrote:
> avoid these checkpatch.pl issues :
> - ERROR: "foo * bar" should be "foo *bar"
> - ERROR: switch and case should be at the same indent
> - ERROR: "(foo*)" should be "(foo *)"
> - ERROR: do not use assignment in if condition
> - ERROR: space required before the open parenthesis '('
> - WARNING: suspect code indent for conditional statements
> - WARNING: quoted string split across lines
> - WARNING: space prohibited between function name and open parenthesis '('
> - WARNING: line over 80 characters
> also add spaces around some "+", "=", "*"
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>

Thanks, applied to for-next.


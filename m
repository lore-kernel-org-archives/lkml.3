Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbaGIJid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:38:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22439 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbaGIJiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:38:17 -0400
Date: Wed, 9 Jul 2014 12:38:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Davide Gianforte <davide@gengisdave.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] staging: silicom: checkpatch fixes
Message-ID: <20140709093808.GU25880@mwanda>
References: <1972083.WZLDx2N35Z@mayhem>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1972083.WZLDx2N35Z@mayhem>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch does too many things, break it up into one type of fix per
patch.

On Tue, Jul 01, 2014 at 02:24:36PM +0200, Davide Gianforte wrote:
> Chechpatch.pl cleanup
> 
> There are still some warnings, most of them are lines over 80 chars
> (mainly a semicolon or closing parenthesis).
> 
> Where not specified, I defaulted printk with no log level into pr_debug

No.  You can't just use pr_debug for everything.  Also some of them are
not whole line prints so the pr_debug() will put extra info in the
middle of the lines.

Write a hello_world.ko kernel module and play with the printk until you
understand what I mean.

regards,
dan carpenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbaAXIFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:05:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37654 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaAXIFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:05:07 -0500
Date: Fri, 24 Jan 2014 11:04:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, josh@joshtriplett.org,
        =?utf-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] drivers: staging: Mark functions as static and remove
 unused function in bpctl_mod.c
Message-ID: <20140124080451.GD7444@mwanda>
References: <20140123224400.GA8124@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140123224400.GA8124@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 04:14:00AM +0530, Rashika Kheria wrote:
> Mark functions as static in bpctl_mod.c because they are not used
> outside this file. Remove unused function from bpctl_mod.c.
> 
> This also eliminates the following warnings from bpctl_mod.c:
> drivers/staging/silicom/bpctl_mod.c:1507:6: warning: no previous prototype for ‘send_bypass_clear_pulse’ [-Wmissing-prototypes]
> drivers/staging/silicom/bpctl_mod.c:1762:5: warning: no previous prototype for ‘cmnd_on’ [-Wmissing-prototypes]

Don't do these massive text blocks.  Just put one or two of the errors
so we get the idea.

regards,
dan carpenter


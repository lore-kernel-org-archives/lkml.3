Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab3EFMvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 08:51:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17109 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3EFMvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 08:51:39 -0400
Date: Mon, 6 May 2013 15:51:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.9
Message-ID: <20130506125114.GA26278@mwanda>
References: <alpine.DEB.2.00.1304291958440.19693@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1304291958440.19693@ayla.of.borg>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These warnings would be more useful if they were in original gcc
format.

drivers/gpu/drm/nouveau/nv50_pm.c:638 nv50_pm_clocks_pre() warn: 'info->mmast' might be uninitialized

That way you can automatically point your text editor at the
offending code.  For the ones where the error happens on multiple
lines then just having the first would be enough.

regards,
dan carpenter


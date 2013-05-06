Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab3EFOWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:22:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35192 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3EFOWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:22:41 -0400
Date: Mon, 6 May 2013 17:22:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.9
Message-ID: <20130506142233.GJ4635@mwanda>
References: <alpine.DEB.2.00.1304291958440.19693@ayla.of.borg>
 <20130506125114.GA26278@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130506125114.GA26278@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the uninitialized variable warnings are false positives in
GCC 4.7 when we optimize for size (-0s).  They are disabled for -0s
with -no-maybe-uninitialized in 3.10.

regards,
dan carpenter


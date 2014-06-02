Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbaFBKbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:31:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20723 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbaFBKbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:31:39 -0400
Date: Mon, 2 Jun 2014 13:30:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Wood <tommyandrena@gmail.com>
Cc: marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ft1000: ft1000-usb: ft1000_debug.c: Fix style
 errors and some warnings.
Message-ID: <20140602103056.GY15585@mwanda>
References: <1401675978-25765-1-git-send-email-tommyandrena@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401675978-25765-1-git-send-email-tommyandrena@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 07:26:18PM -0700, Thomas Wood wrote:
> Don't use spaces as tabs, and fix other style errors and warnings.
>
> Signed-off-by: Thomas Wood <tommyandrena@gmail.com>

Too much in one patch.  Break it up into one type of fix per patch and
send a series of patches.

[patch 1] use tabs
[patch 2] fix braces style
[patch 3] remove parens from return values
[patch 4] reverse an if statement

patch 3 and 4 are small enough that you could get away with pushing them
into a single "misc fixes" patch and we wouldn't have complained but the
first two patches are very big.

regards,
dan carpenter



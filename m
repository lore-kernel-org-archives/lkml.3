Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3I0UrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 16:47:13 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:43406 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3I0UrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 16:47:09 -0400
Message-ID: <5245EECC.4020108@tilera.com>
Date: Fri, 27 Sep 2013 16:47:08 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: tile: re-use kbasename() helper
References: <1380270390-25429-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1380270390-25429-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/27/2013 4:26 AM, Andy Shevchenko wrote:
> kbasename() returns the filename part of a pathname.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  arch/tile/kernel/stack.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)

Thanks!  Taken into the tile tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


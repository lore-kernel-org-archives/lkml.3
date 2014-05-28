Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaE1Wdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:33:55 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:63521 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254AbaE1Wdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:33:54 -0400
Date: Wed, 28 May 2014 15:33:49 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: maps: remove check for CONFIG_MTD_SUPERH_RESERVE
Message-ID: <20140528223349.GF3599@ld-irv-0074>
References: <1400855394.31526.37.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400855394.31526.37.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 04:29:54PM +0200, Paul Bolle wrote:
> Since (a few releases before) v2.6.0 there have been checks for
> CONFIG_MTD_SUPERH_RESERVE. One check is still present. But a Kconfig
> symbol MTD_SUPERH_RESERVE has never been added. So a few lines of dead
> code can be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.

Compile-tested and pushed to l2-mtd.git. Thanks!

Brian

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031054Ab3HIUhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 16:37:11 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61140 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030942Ab3HIUhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 16:37:09 -0400
Date: Fri, 9 Aug 2013 13:32:17 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/4] power: make goldfish_battery depend on GOLDFISH ||
 COMPILE_TEST
Message-ID: <20130809203217.GA12638@lizard.sbx05730.santaca.wayport.net>
References: <1372916353-24050-1-git-send-email-paul.gortmaker@windriver.com>
 <1372916353-24050-3-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1372916353-24050-3-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 01:39:11AM -0400, Paul Gortmaker wrote:
> Nearly all the other goldfish peripherals (mtd, keyboard, etc)
> have a dependency on the main platform's GOLDFISH Kconfig item,
> but this one got skipped.  Even with consistency as a
> justification, there was initial resistance[1] from some people
> to adding it however, as they wanted the extra compile coverage.
> 
> Now, with CONFIG_COMPILE_TEST, we have the middle ground that
> will give people the coverage who want it, and let those who
> don't want it to skip ever seeing the option presented.
> 
> [1] https://lkml.org/lkml/2013/2/27/333
> 
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---

So, CONFIG_AKPM... kinda. :) It works for me. Applied, thank you!

Anton

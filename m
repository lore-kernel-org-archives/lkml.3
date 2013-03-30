Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab3C3BLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 21:11:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35105 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757373Ab3C3BLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 21:11:41 -0400
Date: Sat, 30 Mar 2013 01:11:37 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] regmap: cache: Factor out reg_present support from
	rbtree cache
Message-ID: <20130330011137.GA26560@opensource.wolfsonmicro.com>
References: <1364591025-18525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364591025-18525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 09:03:42PM +0000, Mark Brown wrote:
> The idea of maintaining a bitmap of present registers is something that
> can usefully be used by other cache types that maintain blocks of cached
> registers so move the code out of the rbtree cache and into the generic
> regcache code.
> 
> Refactor the interface slightly as we go to wrap the set bit and enlarge
> bitmap operations (since we never do one without the other) and make it
> more robust for reads of uncached registers by bounds checking before we
> look at the bitmap.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Looks good.

Reviewed-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

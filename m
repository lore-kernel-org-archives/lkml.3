Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934675Ab3BNOhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:37:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57384 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757829Ab3BNOhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:37:53 -0500
Date: Thu, 14 Feb 2013 14:37:51 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2] regmap: debugfs: Simplify calculation of
	`c->max_reg'
Message-ID: <20130214143751.GA23599@opensource.wolfsonmicro.com>
References: <1360850644-15581-1-git-send-email-dp@opensource.wolfsonmicro.com> <20130214141439.GL13249@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214141439.GL13249@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 02:14:40PM +0000, Mark Brown wrote:
> On Thu, Feb 14, 2013 at 02:04:04PM +0000, Dimitris Papastamos wrote:
> 
> > -	unsigned int i, ret;
> > +	unsigned int i = 0, ret;
> 
> Coding style and are you sure this is a good default.

Hm, it doesn't really matter.  I guess the proper fix would
be to set i = base at the start, but that would not change
anything in terms of the actual code flow, it would only silence
the gcc flow analysis bug.

Thanks,
Dimitris

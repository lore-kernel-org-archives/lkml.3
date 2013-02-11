Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab3BKNq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 08:46:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55678 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757215Ab3BKNqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 08:46:23 -0500
Date: Mon, 11 Feb 2013 13:46:21 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regmap: debugfs: Add a registers `range' file
Message-ID: <20130211134621.GA14648@opensource.wolfsonmicro.com>
References: <1360579943-29938-1-git-send-email-dp@opensource.wolfsonmicro.com> <20130211131641.GG4607@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211131641.GG4607@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 01:16:41PM +0000, Mark Brown wrote:
> On Mon, Feb 11, 2013 at 10:52:23AM +0000, Dimitris Papastamos wrote:
> 
> > +struct regmap_reg_range  {
> > +	unsigned int start;
> > +	unsigned int end;
> > +	unsigned int attr;
> > +};
> 
> All we ever do with this struct is
> 
> > +		r.start = c->base_reg;
> > +		r.end = c->max_reg;
> > +		r.attr = c->reg_attr;
> 
> pack it with the contents of a cache entry.  Why not just use the cache
> entry directly?

Yea, will fix and re-send.

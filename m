Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab3HURKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:10:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40733 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663Ab3HURKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:10:03 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Aug 2013 13:10:03 EDT
Date: Wed, 21 Aug 2013 18:03:45 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: David Jander <david.jander@protonic.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: regmap: bugfix in regcache-rbtree.c
Message-ID: <20130821170345.GA15347@opensource.wolfsonmicro.com>
References: <1377090155-3443-1-git-send-email-david@protonic.nl> <20130821133200.GB26118@sirena.org.uk> <20130821162143.42ca91de@archvile> <20130821144442.GD26118@sirena.org.uk> <20130821170846.66b5b1d5@archvile> <20130821152823.GE26118@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821152823.GE26118@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 04:28:23PM +0100, Mark Brown wrote:
> On Wed, Aug 21, 2013 at 05:08:46PM +0200, David Jander wrote:
> 
> > This looks better. Not ideal still, but at least the codec works!
> 
> > Should I re-send a patch with this fix?
> 
> Yes, it's not the fix we actually want (we want to be merging blocks)
> isn't going to be suitable for a bug fix - ideally I'll get this to
> Linus for v3.11.

Once I have some free time I will look into implementing block
merges.

Thanks,
Dimitris

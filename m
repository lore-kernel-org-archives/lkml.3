Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaBCQwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:52:12 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55477 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaBCQwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:52:10 -0500
Date: Mon, 3 Feb 2014 08:52:10 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] regulator: core: Correct default return value for full
 constraints
Message-ID: <20140203165210.GB30754@roeck-us.net>
References: <1390846075-17415-1-git-send-email-broonie@kernel.org>
 <20140203104141.40cc04e5@endymion.delvare>
 <20140203110249.GA6392@sirena.org.uk>
 <20140203153512.3b1d14e4@endymion.delvare>
 <20140203154109.GB22609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140203154109.GB22609@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 03:41:09PM +0000, Mark Brown wrote:
> On Mon, Feb 03, 2014 at 03:35:12PM +0100, Jean Delvare wrote:
> 
> > Ah, I see it in your tree. But it's not in 3.14-rc1. As this fixes a
> > regression, it would be great to have it upstream ASAP, so that it can
> > propagate to 3.13-stable.
> 
> It's on a fixes tag so it'll go in next time I send stuff to Linus,
> it'll go next time I send something to him.  That's usually about once
> per release.  Especially if things are tagged for stable I like to try
> to avoid sending them too quickly unless they're build breaks or
> similar.

We still have the lm90 driver failing in 13.3 for non-DT platforms.
One should think that this has some level of importance. If a driver
doesn't build or doesn't work makes little difference for the user,
after all.

Guenter

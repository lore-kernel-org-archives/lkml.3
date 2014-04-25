Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaDYUa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:30:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41003 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754441AbaDYUa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:30:56 -0400
Date: Fri, 25 Apr 2014 21:30:53 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] regulator: arizona-micsupp: Fix build errors with
	CONFIG_OF not defined
Message-ID: <20140425203053.GA20707@opensource.wolfsonmicro.com>
References: <1398441341-19436-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140425161138.GR12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425161138.GR12304@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 05:11:38PM +0100, Mark Brown wrote:
> On Fri, Apr 25, 2014 at 04:55:40PM +0100, Charles Keepax wrote:
> 
> > Some of the OF handling functions do not have empty alternatives defined
> > if CONFIG_OF is not defined. This patch ifdefs out the offending code.
> 
> Which functions and why is it not better to provide the stubs?

Specifically of_get_child_by_name, of_parse_handle and
of_node_put, I guess stub would probably be better. I will do
a patch for that instead.

Thanks,
Charles

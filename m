Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaDDIdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 04:33:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46436 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962AbaDDIdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 04:33:42 -0400
Date: Fri, 4 Apr 2014 09:33:40 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/3] regulator: core: Add of_node_get to
	of_regulator_match
Message-ID: <20140404083340.GA23464@opensource.wolfsonmicro.com>
References: <1396535537-1352-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140403215027.GD14763@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403215027.GD14763@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 10:50:27PM +0100, Mark Brown wrote:
> On Thu, Apr 03, 2014 at 03:32:15PM +0100, Charles Keepax wrote:
> > Currently, of_regulator_match does not increment the reference count of
> > the of_nodes it takes new references to. This could cause the node
> > pointer held to be invalid, by the time it is passed to the regulator
> > core. This patchs adds an of_node_get when we copy each of_node pointer
> > into the match structure.
> 
> Applied all, thanks.  You just made all users of of_regulator_match()
> buggy - I'm assuming you're going to be fixing that!  :P

Yeah I am on it, just wanted to make sure this was an acceptable
approach before I went off doing loads of patches.

Thanks,
Charles

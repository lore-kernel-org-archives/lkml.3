Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab3CMLye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:54:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53109 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932109Ab3CMLyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:54:33 -0400
Date: Wed, 13 Mar 2013 11:54:30 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regmap: Expose total memory consumption in the
	rbtree debugfs entry
Message-ID: <20130313115430.GA22316@opensource.wolfsonmicro.com>
References: <1363109209-23170-1-git-send-email-dp@opensource.wolfsonmicro.com> <20130313111326.GM25610@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130313111326.GM25610@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 11:13:26AM +0000, Mark Brown wrote:
> On Tue, Mar 12, 2013 at 05:26:49PM +0000, Dimitris Papastamos wrote:
> > Provide a feel of how much overhead the rbtree cache adds to
> > the game.
> 
> Applied, with a tweak to the log to say "used X bytes" for clarity (it's
> arguable if the cached data itself is overhead, depends on what you're
> comparing to).

Aha yes, it makes sense.

Thanks,
Dimitris

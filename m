Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab3COVW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 17:22:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43624 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932531Ab3COVWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 17:22:55 -0400
Date: Fri, 15 Mar 2013 21:22:51 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Remove __attribute__ ((packed))
Message-ID: <20130315212251.GA28907@opensource.wolfsonmicro.com>
References: <1363274779-20671-1-git-send-email-dp@opensource.wolfsonmicro.com> <20130315013640.GG4931@opensource.wolfsonmicro.com> <20130315111602.GB30777@opensource.wolfsonmicro.com> <20130315165351.GA8988@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130315165351.GA8988@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 04:53:51PM +0000, Mark Brown wrote:
> On Fri, Mar 15, 2013 at 11:16:02AM +0000, Dimitris Papastamos wrote:
> 
> > On my system there was no benefit of using it, it just happens
> > that the struct is aligned properly and needs no padding.
> 
> OK, so which system was that and is it not possible that other systems
> will get something useful from this?

Well I guess it has to do with the gcc cross compiler version that
I've got and the actual data layout of the linking rbtree node.
The data seems to be aligned on a 4-byte boundary anyhow and
that should be ok for many systems.

Thanks,
Dimitris

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3COLQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 07:16:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52426 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753282Ab3COLQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:16:05 -0400
Date: Fri, 15 Mar 2013 11:16:02 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Remove __attribute__ ((packed))
Message-ID: <20130315111602.GB30777@opensource.wolfsonmicro.com>
References: <1363274779-20671-1-git-send-email-dp@opensource.wolfsonmicro.com> <20130315013640.GG4931@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130315013640.GG4931@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 01:36:40AM +0000, Mark Brown wrote:
> On Thu, Mar 14, 2013 at 03:26:19PM +0000, Dimitris Papastamos wrote:
> > There is no point having this.  The space gains are trivial if there
> > are any at all.
> 
> Applied, but numbers would have been nice and...
> 
> > Change-Id: Ib4b1320420f780dcf5b9a1e4b05f5805691c4d9f
> 
> ...this shouldn't be in upstream submissions.

Oops, sorry for the Change-Id.

On my system there was no benefit of using it, it just happens
that the struct is aligned properly and needs no padding.

Thanks,
Dimitris

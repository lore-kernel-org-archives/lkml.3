Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab3C3BNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 21:13:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35111 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757370Ab3C3BNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 21:13:30 -0400
Date: Sat, 30 Mar 2013 01:13:27 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regmap: cache: Write consecutive registers in a
	single block write
Message-ID: <20130330011327.GC26607@opensource.wolfsonmicro.com>
References: <1364591025-18525-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1364591025-18525-4-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364591025-18525-4-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 09:03:45PM +0000, Mark Brown wrote:
> When syncing blocks of data using raw writes combine the writes into a
> single block write, saving us bus overhead for setup, addressing and
> teardown.
> 
> Currently the block write is done unconditionally as it is expected that
> hardware which has a register format which can support raw writes will
> support auto incrementing writes, this decision may need to be revised in
> future.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Reviewed-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

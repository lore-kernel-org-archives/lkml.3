Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab3C3BMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 21:12:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35107 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757370Ab3C3BMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 21:12:36 -0400
Date: Sat, 30 Mar 2013 01:12:33 +0000
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] regmap: cache: Factor out block sync
Message-ID: <20130330011233.GA26607@opensource.wolfsonmicro.com>
References: <1364591025-18525-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1364591025-18525-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364591025-18525-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 09:03:43PM +0000, Mark Brown wrote:
> The idea of holding blocks of registers in device format is shared between
> at least rbtree and lzo cache formats so split out the loop that does the
> sync from the rbtree code so optimisations on it can be reused.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Reviewed-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>

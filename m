Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab3ANEz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 23:55:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60368 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754273Ab3ANEz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 23:55:27 -0500
Date: Mon, 14 Jan 2013 13:55:18 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20130114045517.GA4833@opensource.wolfsonmicro.com>
References: <20130114120400.e04269f927629773b0570ff2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130114120400.e04269f927629773b0570ff2@canb.auug.org.au>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 12:04:00PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the sound-asoc tree, today's linux-next build
> (x86_64allmodconfig) failed like this:

Applied, thanks.

> As an aside, should ak4642_of_match be marked "const"?

Probably.

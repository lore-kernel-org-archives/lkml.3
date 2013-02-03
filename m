Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3BCDoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 22:44:22 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:33766 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab3BCDoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 22:44:19 -0500
Date: Sat, 2 Feb 2013 19:40:36 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power/reset: Remove newly introduced __dev* annotations
Message-ID: <20130203034035.GF25016@lizard.sbx00618.mountca.wayport.net>
References: <1359545293-14721-1-git-send-email-thierry.reding@avionic-design.de>
 <20130130113916.GB20242@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130130113916.GB20242@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 12:39:16PM +0100, Andrew Lunn wrote:
> On Wed, Jan 30, 2013 at 12:28:13PM +0100, Thierry Reding wrote:
> > __devinit, __devexit and __devexit_p have recently been removed and
> > should no longer be used.
> > 
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
[...]
> Acked-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!

Anton

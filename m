Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab3AOQLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:11:23 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:50966 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab3AOQLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:11:21 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Tue, 15 Jan 2013 17:10:32 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Dmitry Voytik <dvv.kernel@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2] nconf:  add keybindings for vi-style menu
 navigation, rewrite help texts
Message-ID: <20130115161031.GA5513@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: "Yann E. MORIN" <yann.morin.1998@free.fr>,
	Dmitry Voytik <dvv.kernel@gmail.com>, Michal Marek <mmarek@suse.cz>,
	Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org
References: <20121228185108.GA13644@voyt-hp>
 <1356723607-17027-1-git-send-email-dvv.kernel@gmail.com>
 <20121229223415.GB28355@mobil.systemanalysen.net>
 <201301141924.37268.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201301141924.37268.yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-14 Monday at 19:24 +0100 Yann E. MORIN wrote:
> Roland, All,
> 
> On Saturday 29 December 2012 Roland Eggner wrote:
> > On 2012-12-28 Friday at 23:40 +0400 Dmitry Voytik wrote:
> > > Add alternative vi-style keys for the menu navigation:
> > > <j>/<k> for down/up navigation, <C-f>/<C-b> for
> > > page down/up, <g>/<G> for first/last menu item selection
> > > and <l> for entering to a submenu.
> > 
> > Good starting point, thanks for your initial work.
> > Here is completion of the work:
> 
> I'm sorry, but this patch does not apply cleanly, neither on-top of
> Dmitry's patch, nor on-top of Michal's for-next branch:

Sorry.  Recreated patch versions will follow in replies to this message, the
1st to be applied on vanilla 3.8-rc3, the 2nd to be applied on vanilla 3.2.35.
Unfortunately the patch submitting rules do not allow me to mention this in
subject lines.

Thanks
-- 
Roland Eggner

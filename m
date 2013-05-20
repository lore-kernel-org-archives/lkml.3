Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab3ETRLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:11:34 -0400
Received: from sauhun.de ([89.238.76.85]:60674 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043Ab3ETRLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:11:33 -0400
Date: Mon, 20 May 2013 19:13:07 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/33] drivers/pinctrl: don't check resource with
 devm_ioremap_resource
Message-ID: <20130520171304.GA5797@katana>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
 <1368702961-4325-15-git-send-email-wsa@the-dreams.de>
 <CACRpkda3NM0S_SSkm6aqyx=_i1GOFvJE6rCp29Wnmbo527itPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkda3NM0S_SSkm6aqyx=_i1GOFvJE6rCp29Wnmbo527itPQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 01:39:28PM +0200, Linus Walleij wrote:
> On Thu, May 16, 2013 at 1:15 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> 
> > devm_ioremap_resource does sanity checks on the given resource. No need to
> > duplicate this in the driver.
> >
> > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> 
> I think I have already applied this?

Ah, you already applied the RFC? Shouldn't matter. Linus pulled this
series meanwhile, too.


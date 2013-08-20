Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750923Ab3HTJHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:07:23 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:64380 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3HTJHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:07:21 -0400
Date: Tue, 20 Aug 2013 10:07:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] mfd: mc13xxx: make it possible to use the codec without
 pdata
Message-ID: <20130820090716.GI23699@lee--X1>
References: <1376396148-29801-1-git-send-email-m.grzeschik@pengutronix.de>
 <20130820082636.GH23699@lee--X1>
 <20130820083652.GA17521@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130820083652.GA17521@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > In case of devicetree, we currently don't have a way to append pdata for
> > > the codec. This patch makes it possible to probe the codec without pdata
> > > for that case.
> > > 
> > > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > > ---
> > >  drivers/mfd/mc13xxx-core.c | 11 +++++++----
> > >  1 file changed, 7 insertions(+), 4 deletions(-)
> > 
> > This patch doesn't apply. What tree is it based on?
> Please wait a bit before applying this one. I'd like to get Dmitry's
> feedback on the input one first.

It's okay, I didn't intend on actually applying it. I just wanted to
see the full file changes. I usually apply it, then do a `git log -p
-U1000` to get the full picture. However, I can't even do that yet,
which suggests it's based on some non-upstream tree.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

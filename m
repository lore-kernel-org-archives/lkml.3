Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab3JJLrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:47:00 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:48900 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab3JJLq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:46:59 -0400
Message-ID: <1381405539.24031.102.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH] reset: Add non CONFIG_RESET_CONTROLLER routines
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@linaro.org>,
        Marek Vasut <marex@denx.de>
Date: Thu, 10 Oct 2013 14:45:39 +0300
In-Reply-To: <1381398676.5293.7.camel@pizza.hi.pengutronix.de>
References: <1381396475-17848-1-git-send-email-iivanov@mm-sol.com>
	 <1381398676.5293.7.camel@pizza.hi.pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Thu, 2013-10-10 at 11:51 +0200, Philipp Zabel wrote: 
> Hi Ivan,
> 
> Am Donnerstag, den 10.10.2013, 12:14 +0300 schrieb Ivan T. Ivanov:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > Make sure client drivers will still build on systems
> > without reset control support.
> 
> the stubs should at least return errors, but then this turns a compile
> time error into a runtime error for devices that don't work without
> being properly reset.
> 
> Please also refer to this thread:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/174758.html
> 

I have missed this one. Is there conclusion on the topic? I have
followed approach taken by clock and regulator consumer API.

Regards,
Ivan

> regards
> Philipp
> 



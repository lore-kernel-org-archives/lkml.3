Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3F0Jzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:55:32 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36126 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3F0Jza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:55:30 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 0/7] metag: tz1090: add irq-pdc, pinctrl and gpio to DT
To: Linus Walleij <linus.walleij@linaro.org>,
        James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <CACRpkdYkDEz8xZyhTSNwLx3MvNRDBG+rtP2599KN9CzsCRtQQg@mail.gmail.com>
References: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com> <CACRpkdYkDEz8xZyhTSNwLx3MvNRDBG+rtP2599KN9CzsCRtQQg@mail.gmail.com>
Date: Thu, 27 Jun 2013 10:55:27 +0100
Message-Id: <20130627095527.E94603E0A6F@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013 17:16:06 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Jun 20, 2013 at 2:02 PM, James Hogan <james.hogan@imgtec.com> wrote:
> 
> > This patchset, based on and for the metag tree, adds the necessary
> > device tree nodes and selects the necessary Kconfig symbols in order to
> > enable the irq-imgpdc, {pinctrl,gpio}-tz1090[-pdc] drivers once they are
> > accepted and merged.
> >
> > The first two patches set things up for metag so that we can include
> > <dt-bindings/*> files from device tree files.
> >
> > I plan on applying the first two patches soon, and the others after the
> > corresponding drivers have been accepted into the appropriate trees on
> > which they depend.
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> 
> The series:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Me too, for the series:
Acked-by: Grant Likely <grant.likely@linaro.org>

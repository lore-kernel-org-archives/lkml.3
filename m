Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3CCJXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 04:23:25 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:45536 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab3CCJXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 04:23:17 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] gpio: palmas: add in GPIO support for palmas charger
To: Laxman Dewangan <ldewangan@nvidia.com>, Ian Lartey <ian@slimlogic.co.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
In-Reply-To: <5131ACC3.10803@nvidia.com>
References: <1362157598-11458-1-git-send-email-ian@slimlogic.co.uk> <5131ACC3.10803@nvidia.com>
Date: Sat, 02 Mar 2013 19:35:00 +0000
Message-Id: <20130302193500.783693E1095@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Mar 2013 13:09:47 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> On Friday 01 March 2013 10:36 PM, Ian Lartey wrote:
> > Palmas charger has 16 GPIOs
> > add palmas_gpio_[read|write|update] api to take account
> > second bank of GPIOs
> >
> > Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> > Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> > ---
> 
> Looks good.
> Acked-by: Laxman Dewangan<ldewangan@nvidia.com>
> 

Applied for v3.10, thanks.

g.


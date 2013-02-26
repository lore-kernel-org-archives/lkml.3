Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878Ab3BZT1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:27:20 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:44304 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab3BZT1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:27:18 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 4/4] gpiolib: rename local offset variables to "hwgpio"
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Ryan Mallon <rmallon@gmail.com>,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
In-Reply-To: <1360907177-6468-5-git-send-email-acourbot@nvidia.com>
References: <1360907177-6468-1-git-send-email-acourbot@nvidia.com> <1360907177-6468-5-git-send-email-acourbot@nvidia.com>
Date: Tue, 26 Feb 2013 17:51:54 +0000
Message-Id: <20130226175154.D56DE3E167A@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013 14:46:17 +0900, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Their value being obtained by gpio_chip_hwgpio(), this better reflects
> their use.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

I'm not going to bother with this one. It is churn on things that are
only local variables with no functional change. I would be more inclined
if it was something globably visable, but locals are easy to grok.

g.


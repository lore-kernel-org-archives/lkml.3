Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858Ab3BZT1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:27:19 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43671 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab3BZT1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:27:18 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/4] gpiolib: check descriptors validity before use
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Ryan Mallon <rmallon@gmail.com>,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
In-Reply-To: <1360907177-6468-2-git-send-email-acourbot@nvidia.com>
References: <1360907177-6468-1-git-send-email-acourbot@nvidia.com> <1360907177-6468-2-git-send-email-acourbot@nvidia.com>
Date: Tue, 26 Feb 2013 17:48:39 +0000
Message-Id: <20130226174839.714853E0AEF@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013 14:46:14 +0900, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Some functions dereferenced their GPIO descriptor argument without
> checking its validity first, potentially leading to an oops when given
> an invalid argument.
> 
> This patch also makes gpio_get_value() more resilient when given an
> invalid GPIO, returning 0 instead of silently crashing.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Cc: Ryan Mallon <rmallon@gmail.com>

Applied, thanks.

g.


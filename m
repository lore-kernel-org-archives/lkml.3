Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab3C0INr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:13:47 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:39309 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab3C0INp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:13:45 -0400
MIME-Version: 1.0
In-Reply-To: <1362486116.3660.1.camel@phoenix>
References: <1362486116.3660.1.camel@phoenix>
Date: Wed, 27 Mar 2013 09:13:44 +0100
Message-ID: <CACRpkdayyfbth3Of3R8vpvsP7Ag4YPpRmVS3ry0axH=1rM+L+Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: viperboard: Remove duplicate code to set gpio->gpiob_val
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Lars Poeschel <poeschel@lemonage.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 1:21 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Set it once is enough, and it's done in vprbrd_gpiob_set() which is called by
> vprbrd_gpiob_direction_output().
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied with Lars' Tested/Acked-by.

Thanks!
Linus Walleij

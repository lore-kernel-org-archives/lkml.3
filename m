Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaE1MOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:14:17 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:56948 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaE1MOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:14:16 -0400
MIME-Version: 1.0
In-Reply-To: <1401269165-2996-1-git-send-email-sachin.kamat@linaro.org>
References: <1401269165-2996-1-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 28 May 2014 14:14:15 +0200
Message-ID: <CACRpkdas_Rpkge873ktDE0hoq-0=WUTU_Kibdt5LyFgZ=r_3bA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: ux500: Staticize local symbols in cpu-db8500.c
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 11:26 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> Symbols local to this file are made static.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Patch applied.

Yours,
Linus Walleij

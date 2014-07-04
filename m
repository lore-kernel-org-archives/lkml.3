Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030231AbaGDTzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 15:55:22 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:62331 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964917AbaGDTzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 15:55:21 -0400
MIME-Version: 1.0
In-Reply-To: <1404314924-23564-3-git-send-email-lee.jones@linaro.org>
References: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
	<1404314924-23564-3-git-send-email-lee.jones@linaro.org>
Date: Fri, 4 Jul 2014 21:55:20 +0200
Message-ID: <CACRpkdaEoC0HnNzHeJj2Hw1SKjYxbqEt=AhAFoH5jgWXDQy7jg@mail.gmail.com>
Subject: Re: [PATCH 02/12] mfd: ab8500-debugfs: Simplify invalid debugfs data checking
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 5:28 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Noticed during a coding review, if we reorganised the checking a
> little, we can rid the code of a pointless 'else'.  Whilst looking
> for this particular code hunk I noticed another pointless 'else',
> which I've subsequently fixed in this patch.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

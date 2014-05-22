Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaEVW15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:27:57 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:46274 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaEVW14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:27:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140522113010.GT6679@lee--X1>
References: <1400750311-15323-1-git-send-email-lee.jones@linaro.org>
	<20140522113010.GT6679@lee--X1>
Date: Fri, 23 May 2014 00:27:55 +0200
Message-ID: <CACRpkdYLDt4nyJsMSuMLpa-4JBoGnRFAdcjzDu+km1Yv_qZkeQ@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: abx500-core: Remove unused function abx500_dump_all_banks()
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jay Aurabind <jay.aurabind@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 1:30 PM, Lee Jones <lee.jones@linaro.org> wrote:

> abx500_dump_all_banks() has no callers in the kernel, so it's probably
> safe to remove it.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

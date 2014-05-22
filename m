Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaEVWLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:11:21 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:59683 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaEVWLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:11:19 -0400
MIME-Version: 1.0
In-Reply-To: <1400520995-27365-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1400520995-27365-1-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Fri, 23 May 2014 00:11:19 +0200
Message-ID: <CACRpkda6-W6rNXtAbcTs6dgp4WLExXra6P_dqQbuYsRWi7MaOw@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] ARM: berlin: add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 7:36 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> but can you please drop the Berlin pinctrl patches
> and reconsider taking the reworked driver instead?

Sure I applied patches 1 thru 4 to the pin control tree.
The rest you need to carry in some ARM SoC tree or
similar.

I don't mind the driver being half-merged like this, because
it means we can work on consolidating the utils code
in the next cycle.

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3HUVUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:20:23 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:59928 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3HUVUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:20:20 -0400
MIME-Version: 1.0
In-Reply-To: <1376829629.3391.5.camel@phoenix>
References: <1376829262.3391.1.camel@phoenix>
	<1376829629.3391.5.camel@phoenix>
Date: Wed, 21 Aug 2013 23:20:19 +0200
Message-ID: <CACRpkdZKcYuq47BpvwUVo3ZbKpUNLDFi4tAM7xOtFnSx0a2Evw@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: core: Hold pctldev->mutex mutex lock while
 traversing gpio_ranges list
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 2:40 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Hold pctldev->mutex mutex_lock when traverse the list.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Patch applied.

Yours,
Linus Walleij

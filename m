Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3HPPMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:12:02 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:40131 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3HPPL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:11:59 -0400
MIME-Version: 1.0
In-Reply-To: <1376305541-5857-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1376305541-5857-1-git-send-email-mathias.nyman@linux.intel.com>
Date: Fri, 16 Aug 2013 17:11:57 +0200
Message-ID: <CACRpkda23Ondh-soq645EzdwDvBhvQpnyXczVY8qtLbxh6L7UA@mail.gmail.com>
Subject: Re: [PATCH] gpio-lynxpoint: Fix warning about unbalanced pm_runtime_enable
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 1:05 PM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:

> Missing pm_runtime_disable call in driver remove path caused
> an unbalanaced pm_runtime_enable warning when driver was reloaded
>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Patch applied, thanks!

Yours,
Linus Walleij

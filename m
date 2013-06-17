Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3FQQxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:53:36 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:64453 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3FQQxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:53:34 -0400
MIME-Version: 1.0
In-Reply-To: <1371216160-2595-1-git-send-email-fabio.baltieri@linaro.org>
References: <1371216160-2595-1-git-send-email-fabio.baltieri@linaro.org>
Date: Mon, 17 Jun 2013 18:53:33 +0200
Message-ID: <CACRpkdbkXUkq5VBq8QEf11r=ByqmeyNcxMHkfVs8ip=_O5G4CA@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: add restart support via prcmu
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 3:22 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> Add necessary code to restart ux500 based machines using
> prcmu_system_reset().
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>
> Hi Linus,
>
> this is something I had in my tree for some time.  This adds basic
> soft-reboot support for all ux500 machines using prcmu (the actual
> reboot code was already there) and may also be useful as a base to add
> the remaining "reboot reason" code if necessary.
>
> This is based on your current ste-next branch.

Patch applied.

If you're meriging "reboot reason" code, rename "reason" to
"cause" everywhere. Cause and effect. Causality. Not the
age of reason.

Yours,
Linus Walleij

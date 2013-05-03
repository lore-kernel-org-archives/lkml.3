Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763623Ab3ECUsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:48:21 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:36135 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763577Ab3ECUsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:48:20 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-23-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-23-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 22:48:20 +0200
Message-ID: <CACRpkdb7KFfNTZNwzyvh75k1cbjpxfSrxDW9cchM7cfUK3dmEw@mail.gmail.com>
Subject: Re: [PATCH 22/63] dmaengine: ste_dma40: Move rev error-check up to
 revision acquisition
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:

> At the moment we fetch the hardware revision, then do some stuff, then
> check whether the revision is correct and return in error if it's not.
> Well we may as well check it as soon as we know what it is, so let's
> move the check right up underneath where we acquire the version.
>
> Acked-by: Vinod Koul <vnod.koul@intel.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to my ux500-dm40 branch.

(Notice I didn't apply 20 and 21 so now I'm screwing around.)

Thanks!
Linus Walleij

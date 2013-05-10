Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042Ab3EJEZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 00:25:34 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:59539 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3EJEZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 00:25:33 -0400
Message-ID: <518C76AE.2000909@synopsys.com>
Date: Fri, 10 May 2013 09:55:18 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "christian.ruppert@abilis.com" <christian.ruppert@abilis.com>
Subject: Re: [git pull] GENERIC_GPIO removal
References: <CACxGe6uCJde0vw=zcqJOxdiwOJO8bRe00yzs6UDzup5z-jTRbw@mail.gmail.com> <CA+55aFwU3w2jiA26fCmF3_i+vpf8TMY+8L5=Oso_uMhZX30DQw@mail.gmail.com> <CACxGe6uybaWodG_F_=w7fF=w0X008E+HE7PuT=+a4zTG7-ug4A@mail.gmail.com> <CAAVeFuKBn0oyZSJ50pchTwOCsSdyP5ofx3gaf4h_02xYuZDGSg@mail.gmail.com>
In-Reply-To: <CAAVeFuKBn0oyZSJ50pchTwOCsSdyP5ofx3gaf4h_02xYuZDGSg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 05:21 AM, Alexandre Courbot wrote:
>
> /me likes regexps. You should see my workaround to using the -i option.
>
> Thanks for the merge, it clears the path for more GPIO stuff. arch/arc
> introduced a new dangling definition of GENERIC_GPIO in -next that now
> appears in your tree, the following patch by Vineet takes care of it.
> Either you can merge it directly or Vineet will make sure this patch
> is in his next pull request.
>
> Alex.
>
> -----8<-----8<-----8<
> From: Vineet Gupta <vgupta@synopsys.com>
> Date: Wed, 17 Apr 2013 17:33:02 +0530
> Subject: [PATCH] ARC: [TB10x] Remove GENERIC_GPIO
>
> This tracks Alexandre Courbot's mainline GPIO rework
>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Acked-by: Alexandre Courbot <acourbot@nvidia.com>
> ---

With both the prerequisites (ARC-TB10x && GENERIC_GPIO) now in Linus' tree, I've
added it to my for-curr to be sent to Linus later today.

Thx,
-Vineet

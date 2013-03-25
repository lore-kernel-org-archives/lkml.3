Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab3CYFjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 01:39:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35100 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab3CYFj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 01:39:28 -0400
Message-ID: <514FE307.5090201@ti.com>
Date: Mon, 25 Mar 2013 11:09:19 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Prabhakar lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 2/2] media: davinci: vpbe: venc: move the enabling of
 vpss clocks to driver
References: <1363938793-22246-1-git-send-email-prabhakar.csengg@gmail.com> <1363938793-22246-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1363938793-22246-3-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/22/2013 1:23 PM, Prabhakar lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> The vpss clocks were enabled by calling a exported function from a driver
> in a machine code. calling driver code from platform code is incorrect way.
> 
> This patch fixes this issue and calls the function from driver code itself.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  Note: This patch is based on the comment from Sekhar
>       (https://patchwork-mail1.kernel.org/patch/2278441/).
>       Shekar I haven't completely removed the callback, I just added
>       the function calls after the callback. As you mentioned just to
>       pass the VPSS_CLK_CTRL as a resource to venc but the VPSS_CLK_CTRL
>       is already being used by VPSS driver. I'll take this cleanup task later
>       point of time.

Fine by me.

Thanks,
Sekhar

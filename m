Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab3KKXIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:08:13 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59843 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab3KKXIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:08:06 -0500
Message-ID: <5281634F.2050607@ti.com>
Date: Mon, 11 Nov 2013 17:07:59 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <tony@atomide.com>
Subject: Re: [patch] mailbox/omap: make mbox->irq signed for error handling
References: <20131107074918.GG21844@elgon.mountain>
In-Reply-To: <20131107074918.GG21844@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/07/2013 01:49 AM, Dan Carpenter wrote:
> There is a bug in omap2_mbox_probe() where we try do:
>
> 		mbox->irq = platform_get_irq(pdev, info->irq_id);
> 		if (mbox->irq < 0) {
>
> The problem is that mbox->irq is unsigned so the error handling doesn't
> work.  I've changed it to a signed integer.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

LGTM, thanks for the fix.

regards
Suman

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3A1Pdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:33:43 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:34717 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab3A1Pdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:33:42 -0500
Message-ID: <51069A3A.8090404@ti.com>
Date: Mon, 28 Jan 2013 21:03:14 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LAK <linux-arm-kernel@lists.infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, Heiko Schocher <hs@denx.de>
Subject: Re: [PATCH] ARM: davinci: da850: add interrupt-parent property in
 soc node
References: <1359112724-1217-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1359112724-1217-1-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/2013 4:48 PM, Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> This patch adds 'interrupt-parent' property in soc node, so that
> the child inherits this property, this avoids adding 'interrupt-parent'
> to each node.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: davinci-linux-open-source@linux.davincidsp.com
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Heiko Schocher <hs@denx.de>
> ---

Looks good to me. Queuing for v3.9. BTW, we are moving the interrupt
parent property to soc node rather than adding it. So, I think a better
headline is "move interrupt-parent property to soc node". I change the
headline while committing.

Thanks,
Sekhar

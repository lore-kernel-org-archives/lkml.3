Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbaBKVVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:21:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaBKVVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:21:40 -0500
Date: Tue, 11 Feb 2014 13:21:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robherring2@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCHv3 1/2] mm/memblock: add memblock_get_current_limit
Message-Id: <20140211132137.14af32f551f12630b1629f50@linux-foundation.org>
In-Reply-To: <1392153265-14439-2-git-send-email-lauraa@codeaurora.org>
References: <1392153265-14439-1-git-send-email-lauraa@codeaurora.org>
	<1392153265-14439-2-git-send-email-lauraa@codeaurora.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014 13:14:24 -0800 Laura Abbott <lauraa@codeaurora.org> wrote:

> Appart from setting the limit of memblock, it's also useful to be able
> to get the limit to avoid recalculating it every time. Add the function
> to do so.
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Please add my acked-by to this.  You might also add a note that I do not ack
your spelling of "apart" ;)


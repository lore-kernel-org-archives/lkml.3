Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaBEWBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:01:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaBEWBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:01:15 -0500
Date: Wed, 5 Feb 2014 14:01:13 -0800
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
Subject: Re: [PATCHv2 1/2] mm/memblock: add memblock_get_current_limit
Message-Id: <20140205140113.f02dd196c88ad2cf55123b9e@linux-foundation.org>
In-Reply-To: <1391558551-31395-2-git-send-email-lauraa@codeaurora.org>
References: <1391558551-31395-1-git-send-email-lauraa@codeaurora.org>
	<1391558551-31395-2-git-send-email-lauraa@codeaurora.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Feb 2014 16:02:30 -0800 Laura Abbott <lauraa@codeaurora.org> wrote:

> Appart from setting the limit of memblock, it's also useful to be able
> to get the limit to avoid recalculating it every time. Add the function
> to do so.

Looks OK to me.  Your "[PATCHv2 2/2] arm: Get rid of meminfo" did not
make it into my inbox or into my lkml folder, but I found it at
lkml.org so the server did send it.  I'm not sure what's up with that.

Please include [patch 1/2] within or alongside [patch 2/2] so they both
get merged via the same route, which is presumably an arm tree.


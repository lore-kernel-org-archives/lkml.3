Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaBEXTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 18:19:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44702 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbaBEXTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:19:37 -0500
Message-ID: <52F2C700.8070502@ti.com>
Date: Wed, 5 Feb 2014 18:19:28 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laura Abbott <lauraa@codeaurora.org>
CC: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robherring2@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCHv2 1/2] mm/memblock: add memblock_get_current_limit
References: <1391558551-31395-1-git-send-email-lauraa@codeaurora.org> <1391558551-31395-2-git-send-email-lauraa@codeaurora.org>
In-Reply-To: <1391558551-31395-2-git-send-email-lauraa@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 February 2014 07:02 PM, Laura Abbott wrote:
> Appart from setting the limit of memblock, it's also useful to be able
> to get the limit to avoid recalculating it every time. Add the function
> to do so.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>


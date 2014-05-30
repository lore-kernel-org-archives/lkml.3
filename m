Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978AbaE3SVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 14:21:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34612 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964826AbaE3SVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 14:21:04 -0400
Date: Fri, 30 May 2014 19:20:37 +0100
From: Will Deacon <will.deacon@arm.com>
To: Larry Bassel <larry.bassel@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH v6 1/2] arm64: adjust el0_sync so that a function can be
 called
Message-ID: <20140530182037.GH22895@arm.com>
References: <1401399904-24471-1-git-send-email-larry.bassel@linaro.org>
 <1401399904-24471-2-git-send-email-larry.bassel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401399904-24471-2-git-send-email-larry.bassel@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 10:45:03PM +0100, Larry Bassel wrote:
> To implement the context tracker properly on arm64,
> a function call needs to be made after debugging and
> interrupts are turned on, but before the lr is changed
> to point to ret_to_user(). If the function call
> is made after the lr is changed the function will not
> return to the correct place.
> 
> For similar reasons, defer the setting of x0 so that
> it doesn't need to be saved around the function call
> (save far_el1 in x26 temporarily instead).

  Acked-by: Will Deacon <will.deacon@arm.com>

Thanks guys!

Will

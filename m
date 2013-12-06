Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab3LFA6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:58:37 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58198 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3LFA6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:58:35 -0500
Date: Thu, 5 Dec 2013 18:58:29 -0600
From: rkuo <rkuo@codeaurora.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arc: kernel: add default extern variable 'screen_info'
 in "setup.c"
Message-ID: <20131206005829.GA7615@codeaurora.org>
References: <529707B9.1090809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529707B9.1090809@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 05:07:05PM +0800, Chen Gang wrote:
> Hello Vineet:
> 
> hexagon meets the same issue, could you help send related patch for it?
> 
> If you have no time, please let me know, I should send it within next
> month.
> 
> BTW: I assume hexagon need not support VGA_CONSOLE, either, if it is
> incorrect, please let me know thanks.
> 
> 

Just to chime in on this one, Hexagon probably won't have the hardware,
but we would still like to be able to compile the code, so I will fix this
in Hexagon's arch tree.

Thanks for the help,
Richard Kuo


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaGNRXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:23:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50322 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaGNRXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:23:34 -0400
Message-ID: <53C41213.6020102@codeaurora.org>
Date: Mon, 14 Jul 2014 10:23:31 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 1/3] asm-generic/io.h: Implement generic {read,write}s*()
References: <1405092672-18549-1-git-send-email-thierry.reding@gmail.com> <53C05E4A.2030708@codeaurora.org> <20140714091057.GP2081@ulmo>
In-Reply-To: <20140714091057.GP2081@ulmo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/14 02:10, Thierry Reding wrote:
> The reason behind this was that people have been told to migrate towards
> using io{read,write}{8,16,32}_rep() because {read,write}s{b,w,l}() are
> not as "portable". The only reason why the aren't portable is because no
> generic versions of them existed. That's what this series originally
> started out as.
>
> Also, it's somewhat backwards (and inconsistent) to go through the io*()
> functions when it's known up front that the device will always only be
> memory-mapped and never I/O mapped. So with these patches going forward,
> people should be using either {read,write}{,s}{b,w,l}() *or* their
> io{read,write}{8,16,32}{,_rep}() counterparts, not mixing them.
>

Thanks. Can we please have this explanation in the commit text?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


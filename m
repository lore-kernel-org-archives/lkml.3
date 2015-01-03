Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbbACPkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 10:40:12 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45343 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbbACPkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 10:40:09 -0500
Date: Sat, 3 Jan 2015 09:39:30 -0600
From: Nishanth Menon <nm@ti.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Tony Lindgren <tony@atomide.com>,
        "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>,
        Russell King <linux@arm.linux.org.uk>, Santosh <ssantosh@kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH V2 0/2] ARM: l2c: OMAP4/AM437x: Additional register
 programming support.\
Message-ID: <20150103153930.GA26181@kahuna>
References: <1420220628-23742-1-git-send-email-nm@ti.com>
 <54A6E79E.7010203@oracle.com>
 <54A6F5C8.2050008@ti.com>
 <20150103002317.GH3298@atomide.com>
 <CA+Ln22E0_R1cXXgF_L8kdz+cTmAkhykTtN04=q6JXNsUsFv9Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+Ln22E0_R1cXXgF_L8kdz+cTmAkhykTtN04=q6JXNsUsFv9Eg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:42-20150103, Tomasz Figa wrote:
> Indeed, as I figured out in the original thread about this issue,
> additional patch fixing code unaffected by my series (besides changing
> the condition which triggers calling it) is necessary. Namely, the
> affected 4 registers need to be written using the write_sec wrapper,
> instead of using writel*() directly.
> 

Agreed. Would you like to post a patch (independent) of your series to address
this - sounds like a fix that should go in independent of your original
series.

-- 
Regards,
Nishanth Menon

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab3CLQJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:09:27 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:35333 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab3CLQJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:09:26 -0400
Date: Tue, 12 Mar 2013 17:09:12 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jonas Gorski <jogo@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Chris Dearman <chris.dearman@imgtec.com>
Subject: Re: [PATCH v2] MIPS: Get rid of CONFIG_CPU_HAS_LLSC again
Message-ID: <20130312160911.GA17165@linux-mips.org>
References: <1362477800.16460.69.camel@x61.thuisdomein>
 <CAOiHx=nzNVatEp0nyfZKU2p35+1kjrw6VsvZTP+QPJykWF3JAg@mail.gmail.com>
 <1362486020.16460.73.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362486020.16460.73.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 01:20:20PM +0100, Paul Bolle wrote:

> Commit f7ade3c168e4f437c11f57be012992bbb0e3075c ("MIPS: Get rid of
> CONFIG_CPU_HAS_LLSC") did what it promised to do. But since then that
> macro and its Kconfig symbol popped up again. Get rid of those again.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) This version fixes an embarrassing dangling "#endif" spotted by
> Jonas. Thanks for that! Still untested.

Thanks, I've applied your v2 patch.

It's good that your cleanup doesn't change the behaviour of the existing
code - however the current behaviour doesn't seem to be the intended
behaviour so I'm going to commit a separate patch to define cpu_has_llsc
to 1.

  Ralf

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab3EMQmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:42:45 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:45350 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752812Ab3EMQmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:42:43 -0400
Date: Mon, 13 May 2013 17:42:24 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: majianpeng <majianpeng@gmail.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] module: Add section ".ref.data" into
 kmemleak-scan-area.
Message-ID: <20130513164223.GF18828@arm.com>
References: <518DAA1A.3010407@gmail.com>
 <87bo8f39di.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo8f39di.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 03:24:09AM +0100, Rusty Russell wrote:
> majianpeng <majianpeng@gmail.com> writes:
> 
> > In commit 523c81135,it used "__refdata" on event_class_ftrace_##call.
> > It will cause kmemleak to misjudge because when loading module it did
> > not add '.ref.data' into kmemleak-scan-area.
> > 
> > Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> > ---
> >  kernel/module.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Catalin?
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Looks good, thanks for cc'ing me.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

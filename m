Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaITKGn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 06:06:43 -0400
Received: from mailsec108.isp.belgacom.be ([195.238.20.104]:3791 "EHLO
	mailsec108.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183AbaITKGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 06:06:41 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=UGN7JNw3bPEHpwjh5ACRRBK85/3fvewMg9DN/Z6sboU= c=1 sm=2
 a=JwWjpQ3SU8kA:10 a=FwaN3CsL69sA:10 a=IkcTkHD0fZMA:10 a=Z4Rwk6OoAAAA:8
 a=KtBPcdLXCKMx5fe_6S4A:9 a=QEXdDO2ut3YA:10 a=jbrJJM5MRmoA:10
 a=P3CUOhJmT5seMe0Z:21 a=A0I-HRPSLpJUhFQ5:21
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhULAPFPHVTD7hTU/2dsb2JhbABggw2BKoMBslABAQEBAQEGm38BfRYBeYQDAQEBAwEjBFIFCwUGDgoCAhgOAgJXBhMRiCUMrG2Gf48JGIEshGGJeQeCeIFTBZEtoTSDYjsvgkoBAQE
Date: Sat, 20 Sep 2014 12:06:40 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Message-ID: <297345823.196267.1411207600196.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20140919160032.5863df2729d42df7c0b58825@linux-foundation.org>
References: <1410642756-24237-1-git-send-email-fabf@skynet.be> <20140919160032.5863df2729d42df7c0b58825@linux-foundation.org>
Subject: Re: [PATCH V3 RESEND] SYSV: logging update
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 20 September 2014 at 01:00 Andrew Morton <akpm@linux-foundation.org> wrote:
>
>
> On Sat, 13 Sep 2014 23:12:36 +0200 Fabian Frederick <fabf@skynet.be> wrote:
>
> > -use current logging functions
> > -replace no level printk by pr_err
> > -add debug.c / sysv_err function to include sb->s_id
> > -use pr_fmt with standard KBUILD_MODNAME ": "
> > -use __builtin_return_address to display function name
> > logging format is now:
> > sysv: (sb->s_id) sysv_fill_super [sysv]: msg
>
> Is this patch tested?

Yes but looking at it again I wonder if __builtin_return_address is the best
function to use. %pf displays "sysv_fill_super [sysv]".
Maybe a trivial question but is there a way to have it simply display function
name ?

Of course I hope to have more feedback/testing to improve this patch.

Regards,
Fabian

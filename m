Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaC1Rkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:40:33 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:38892 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbaC1RbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140328172229.GH29656@kvack.org>
References: <20140327134653.GA22407@kvack.org>
	<CA+55aFzFgY4-26SO-MsFagzaj9JevkeeT1OJ3pjj-tcjuNCEeQ@mail.gmail.com>
	<CA+55aFx7vg2rvOu6Bu_e8+BB=ymoUMp0AM9JmAuUuSgo0LVEwg@mail.gmail.com>
	<20140327200851.GL17679@kvack.org>
	<CA+55aFy_sRnFu7KguAUAN5kbHk3Qa_0ZuATPU5i8LOyMMWZ_5g@mail.gmail.com>
	<20140327205749.GM17679@kvack.org>
	<CA+55aFyj2XFMkT1T=EPPw1CANt6atyFNmMaeaDm-p-NWfRNA+w@mail.gmail.com>
	<20140328145826.GE29656@kvack.org>
	<CA+55aFyye6K4ifJ778uZ_pNFKa7=R0KsKREmJkimEQxW3nDhDA@mail.gmail.com>
	<20140328172229.GH29656@kvack.org>
Date: Fri, 28 Mar 2014 10:31:11 -0700
X-Google-Sender-Auth: AyPaT2fk0cEJ2PfPfB3Gl-E2G08
Message-ID: <CA+55aFyAOja7MhQTfXqXkVREAY4p93PssCdGACag1me=gXEdrg@mail.gmail.com>
Subject: Re: git pull -- [PATCH] aio: v2 ensure access to ctx->ring_pages is
 correctly serialised
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, linux-aio@kvack.org,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 10:22 AM, Benjamin LaHaise <bcrl@kvack.org> wrote:
>
> I believe it was found by analysis.  I'd be okay with it baking for another
> week or two before pushing it to stable, as that gives the folks running
> various regression tests some more time to chime in.  Better to get it
> right than to have to push another fix.

Ok. If we have no actual user problem reports due to this, I'll just
expect to get a pull request later, and ignore it for 3.14 since the
risk (even though small) seems unnecessary.

                Linus

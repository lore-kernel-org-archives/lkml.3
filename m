Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaC1RIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:08:50 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:59121 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaC1RIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:08:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140328145826.GE29656@kvack.org>
References: <20140327134653.GA22407@kvack.org>
	<CA+55aFzFgY4-26SO-MsFagzaj9JevkeeT1OJ3pjj-tcjuNCEeQ@mail.gmail.com>
	<CA+55aFx7vg2rvOu6Bu_e8+BB=ymoUMp0AM9JmAuUuSgo0LVEwg@mail.gmail.com>
	<20140327200851.GL17679@kvack.org>
	<CA+55aFy_sRnFu7KguAUAN5kbHk3Qa_0ZuATPU5i8LOyMMWZ_5g@mail.gmail.com>
	<20140327205749.GM17679@kvack.org>
	<CA+55aFyj2XFMkT1T=EPPw1CANt6atyFNmMaeaDm-p-NWfRNA+w@mail.gmail.com>
	<20140328145826.GE29656@kvack.org>
Date: Fri, 28 Mar 2014 10:08:47 -0700
X-Google-Sender-Auth: Khv7G_4gfNIIjbvw3Hc0aScuZf8
Message-ID: <CA+55aFyye6K4ifJ778uZ_pNFKa7=R0KsKREmJkimEQxW3nDhDA@mail.gmail.com>
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

On Fri, Mar 28, 2014 at 7:58 AM, Benjamin LaHaise <bcrl@kvack.org> wrote:
>
> Here's a respin of that part.  I just moved the mutex initialization up so
> that it's always valid in the err path.  I have also run this version of
> the patch through xfstests and my migration test programs and it looks
> okay.

Ok. I can't find any issues with this version. How critical is this?
Should I take it now, or with more testing during the 3.15 merge
window and then just have it picked up from stable? Do people actually
trigger the bug in real life, or has this been more of a
trinity/source code analysis thing?

                Linus

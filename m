Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab3LVVep (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 16:34:45 -0500
Received: from kanga.kvack.org ([205.233.56.17]:36710 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726Ab3LVVeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 16:34:44 -0500
Date: Sun, 22 Dec 2013 16:34:43 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Kristian Nielsen <knielsen@knielsen-hq.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, Dave Jones <davej@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: GPF in aio_migratepage
Message-ID: <20131222213443.GA6891@kvack.org>
References: <20131126032645.GA32301@redhat.com> <20131126060132.GA6400@redhat.com> <20131126071953.GE9244@kmo-pixel> <20131126152337.GL15489@kvack.org> <87d2lh6h92.fsf@frigg.knielsen-hq.org> <529C5CA6.6090708@cn.fujitsu.com> <20131202174913.GA18853@redhat.com> <87ob4hu66n.fsf@frigg.knielsen-hq.org> <52AE6C4A.9080203@cn.fujitsu.com> <871u14ty2q.fsf@frigg.knielsen-hq.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u14ty2q.fsf@frigg.knielsen-hq.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kristian,

On Sun, Dec 22, 2013 at 09:44:45PM +0100, Kristian Nielsen wrote:
> There are other changes in that area since 3.13-rc1 though.
> 
> Anyway, I am now running with 3.13-rc4 and will report if I see anything.
> Given that I do not have any way to reproduce (I only ever saw this once),
> this seems the best that can be done for now.

Linus just pushed out 3.13-rc5 that has changes to aio_migratepage() that 
should make it much more robust, as well as other fixes.  Can you please 
give it a spin as well and let me know if it works?  Thanks a bunch!

		-ben

> Thanks for following up on this!
> 
>  - Kristian.

-- 
"Thought is the essence of where you are now."

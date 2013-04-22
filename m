Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab3DVMBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:01:31 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37991
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435Ab3DVMBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:01:30 -0400
Message-ID: <1366632078.4443.15.camel@laptop>
Subject: Re: [PATCH v2 0/6] correct load_balance()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Date: Mon, 22 Apr 2013 14:01:18 +0200
In-Reply-To: <20130422080135.GA19454@lge.com>
References: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <20130422080135.GA19454@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-22 at 17:01 +0900, Joonsoo Kim wrote:

> Hello, Ingo and Peter.
> 
> Just ping for this patchset.

The patches look fine -- except a few cosmetic changes. I'm fine with
Ingo taking them now and merging a 7/6 patch that clears up the
cosmetic issues or you can repost with them taken care of.

I'll leave that up to you and Ingo.

Otherwise:

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks!


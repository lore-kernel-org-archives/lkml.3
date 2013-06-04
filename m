Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3FDIty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:49:54 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47154 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751317Ab3FDItr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:49:47 -0400
Date: Tue, 4 Jun 2013 09:48:32 +0100
From: Will Deacon <will.deacon@arm.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'richard -rw- weinberger'" <richard.weinberger@gmail.com>,
        "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: A bug about system call on ARM
Message-ID: <20130604084832.GA27516@mudshark.cambridge.arm.com>
References: <20130530114112.GH7483@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B86D@CNBJMBX05.corpusers.net>
 <20130531084638.GB4928@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B874@CNBJMBX05.corpusers.net>
 <20130531111305.GI4928@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B876@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D1610991B87B@CNBJMBX05.corpusers.net>
 <20130603095425.GA32242@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B87E@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D1610991B883@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D1610991B883@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 06:33:20AM +0100, Wang, Yalin wrote:
> Hi  Will,

Hello,

> Could I know  what's your git branch is  mainly used for ?
> 
> https://git.kernel.org/cgit/linux/kernel/git/will/linux.git
> 
> 
> I mean if the branch is used for ARM arch maintenance ?

I send most of my patches via Russell, and the tree above is where I keep my
patches whilst they're not yet in mainline.

> If yes, I think I can send future bugs about ARM to you directly,
> And do not need ping-pang in the mail list .

Quite the opposite! Having discussions on the mailing list is key to how the
kernel is developed, so please continue to send questions, bug reports and
patches there. As has been pointed out previously in this thread, you need
to choose the right list in the first place, rather than just sending to
LKML.

Of course, you can always CC me on arm/arm64 patches if you like.

Cheers,

Will

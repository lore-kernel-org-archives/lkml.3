Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab3FDJab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:30:31 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:5269 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738Ab3FDJa3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:30:29 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>
CC: "'richard -rw- weinberger'" <richard.weinberger@gmail.com>,
        "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 4 Jun 2013 17:30:04 +0800
Subject: RE: A bug about system call on ARM
Thread-Topic: A bug about system call on ARM
Thread-Index: Ac5hAHOO7jTH3KtSQiqTdjXo/WWMfQABXi2w
Message-ID: <35FD53F367049845BC99AC72306C23D1610991B88F@CNBJMBX05.corpusers.net>
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
 <20130604084832.GA27516@mudshark.cambridge.arm.com>
In-Reply-To: <20130604084832.GA27516@mudshark.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

Thanks for your reply,
I see your meaning ,
But it seems my apply for joining into 'linux-arm-kernel@lists.infradead.org'
Is not approved ,  
How to join in this mail-list ?

Thanks for your help .

-----Original Message-----
From: Will Deacon [mailto:will.deacon@arm.com] 
Sent: Tuesday, June 04, 2013 4:49 PM
To: Wang, Yalin
Cc: 'richard -rw- weinberger'; 'linux-arch@vger.kernel.org'; 'linux-kernel@vger.kernel.org'; 'linux-arm-kernel@lists.infradead.org'
Subject: Re: A bug about system call on ARM

On Tue, Jun 04, 2013 at 06:33:20AM +0100, Wang, Yalin wrote:
> Hi  Will,

Hello,

> Could I know  what's your git branch is  mainly used for ?
> 
> https://git.kernel.org/cgit/linux/kernel/git/will/linux.git
> 
> 
> I mean if the branch is used for ARM arch maintenance ?

I send most of my patches via Russell, and the tree above is where I keep my patches whilst they're not yet in mainline.

> If yes, I think I can send future bugs about ARM to you directly, And 
> do not need ping-pang in the mail list .

Quite the opposite! Having discussions on the mailing list is key to how the kernel is developed, so please continue to send questions, bug reports and patches there. As has been pointed out previously in this thread, you need to choose the right list in the first place, rather than just sending to LKML.

Of course, you can always CC me on arm/arm64 patches if you like.

Cheers,

Will

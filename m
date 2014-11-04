Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaKDBps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:45:48 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:12338 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbaKDBpr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:45:47 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Joe Perches <joe@perches.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 4 Nov 2014 09:45:42 +0800
Subject: RE: [RFC V6 3/3] arm64:add bitrev.h file to support rbit instruction
Thread-Topic: [RFC V6 3/3] arm64:add bitrev.h file to support rbit
 instruction
Thread-Index: Ac/3S6wTI0zxMshrQ4qGSbsKS1fzQAAhTWMw
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D18288@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18265@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18266@CNBJMBX05.corpusers.net>
 <20141030120127.GC32589@arm.com>
 <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
 <20141030135749.GE32589@arm.com>
 <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18274@CNBJMBX05.corpusers.net>
 <20141031104305.GC6731@arm.com>
 <35FD53F367049845BC99AC72306C23D103E010D18287@CNBJMBX05.corpusers.net>
 <CAKv+Gu-+fe9Hj-uGQHq8KR_6WjrQL-1q=xVBSXVXg2EJO=MW2w@mail.gmail.com>
 <20141103095051.GA23019@arm.com>
In-Reply-To: <20141103095051.GA23019@arm.com>
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

> From: Will Deacon [mailto:will.deacon@arm.com]
> >
> > If this is the case, I suggest you update patch 8187/1 to retain the
> > byte_rev_table symbol, even in the accelerated case, and remove it
> > with a followup patch once Joe's patches have landed upstream. Also, a
> > link to the patches would be nice, and perhaps a bit of explanation
> > how/when they are expected to be merged.
> 
> Indeed, or instead put together a series with the appropriate acks so
> somebody can merge it all in one go. Merging this on a piecemeal basis is
> going to cause breakages (as you pointed out).
> 
> Will

Hi  Will,
Could I add you as ack-by , and submit these 2 patches into the
Patch system ?
So you can merge them together .

Thanks

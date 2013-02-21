Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab3BUHjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 02:39:44 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:58442 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab3BUHjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 02:39:42 -0500
Message-ID: <5125CED4.7030905@synopsys.com>
Date: Thu, 21 Feb 2013 13:07:56 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.next,gmane.linux.kernel,gmane.linux.ports.arm.kernel
To: James Hogan <james.hogan@imgtec.com>
CC: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        <arm@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>
Subject: Re: [PATCH 01/11] ARM: disable virt_to_bus/virt_to_bus almost everywhere
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de> <1360849767-1463135-2-git-send-email-arnd@arndb.de> <CAAG0J9_VqCGJJJZjSWGfFggALHU=vdWsSBeS39-DtxV=VXcJwQ@mail.gmail.com> <201302201600.47522.arnd@arndb.de> <5124FA93.5090504@imgtec.com>
In-Reply-To: <5124FA93.5090504@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I guess you'll have to do something similar for arch/metag, and Vineet
>> will do it for arch/arc.

After getting the tip-bot msg about Stephen's patch for -mm, I never saw it in
-next and thus was not sure how when it will start showing up in -next.

> 
> Yes, I have a little series of patches to fix this sort of harmless
> thing in arch/metag, removing GENERIC_SIGALTSTACK, HAVE_IRQ_WORK,
> ARCH_NO_VIRT_TO_BUS, and CONFIG_EXPERIMENTAL from defconfigs. I wasn't
> sure how it's normally handled though, so I was just going to wait until
> the other things go in before requesting a second pull.

Yes I also have a TODO list which certainly had most of those - but thanks for the
complete list James :-)


>> Stephen's patch is currently in Andrew's tree, and I don't see an easy
>> way to coordinate this. The patch we will need once both are merged
>> is below.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> FWIW:
> Acked-by: James Hogan <james.hogan@imgtec.com> (for arch/metag)
> 
> Cheers
> James

Acked-by: Vineet Gupta <vgupta@synopsys.com> (for arch/arc)

So this means Stephen's patch - once merged will take care of existing in-tree
arches and your's will take care of metag/arc.

Thx,
-Vineet

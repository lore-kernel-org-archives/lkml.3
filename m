Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaLES7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:59:55 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:55605 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaLES7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:59:54 -0500
MIME-Version: 1.0
In-Reply-To: <20141205184418.GF31222@e104818-lin.cambridge.arm.com>
References: <35FD53F367049845BC99AC72306C23D103D6DB491609@CNBJMBX05.corpusers.net>
 <20140915113325.GD12361@n2100.arm.linux.org.uk> <20141204120305.GC17783@e104818-lin.cambridge.arm.com>
 <20141205120506.GH1630@arm.com> <20141205170745.GA31222@e104818-lin.cambridge.arm.com>
 <20141205172701.GW11285@n2100.arm.linux.org.uk> <20141205184418.GF31222@e104818-lin.cambridge.arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 5 Dec 2014 18:59:32 +0000
Message-ID: <CAFEAcA_4ZNq-mxEK82nXAMJCg8oSyqXeUte3wGXHcLv5dWr_OQ@mail.gmail.com>
Subject: Re: [RFC v2] arm:extend the reserved mrmory for initrd to be page aligned
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Maydell <Peter.Maydell@arm.com>,
        "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 December 2014 at 18:44, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Fri, Dec 05, 2014 at 05:27:02PM +0000, Russell King - ARM Linux wrote:
>> which makes the summary line rather misleading, and I really don't think
>> we need to do this on ARM for the simple reason that we've been doing it
>> for soo long that it can't be an issue.
>
> I started this as a revert and then realised that it doesn't solve
> anything for arm32 without changing the poisoning.
>
> Anyway, if you are happy with how it is, I'll drop the arm32 part. As I
> said yesterday, the issue is worse for arm64 with 64K pages.

If you do want to retain the arm32 "mustn't be in the 4K page of
the initrd tail" behaviour then it would probably be a good idea
to document this in the Booting spec.

thanks
-- PMM

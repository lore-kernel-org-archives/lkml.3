Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbaAUKOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:14:20 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53102 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753982AbaAUKOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:14:18 -0500
Date: Tue, 21 Jan 2014 10:14:07 +0000
From: Will Deacon <will.deacon@arm.com>
To: naveen yadav <yad.naveen@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: spinlock lockup
Message-ID: <20140121101407.GD30706@mudshark.cambridge.arm.com>
References: <CAJ8eaTzT4Os5RjtTu5gWpA=t-8Gg9rwmthEHVUOf+3+XhRpu6Q@mail.gmail.com>
 <20140120102051.GB16496@mudshark.cambridge.arm.com>
 <CAJ8eaTwH3kov0Bo_sCDvgxzQWtRB2tKit=_rKFBhQ6jBZcND-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8eaTwH3kov0Bo_sCDvgxzQWtRB2tKit=_rKFBhQ6jBZcND-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 06:37:31AM +0000, naveen yadav wrote:
> Thanks for your reply,
> 
> We are using Cortex A15.
> yes,  this is with ticket lock.
> 
> We will check value of arch_spinlock_t and share it. It is bit
> difficult to reproduce this scenario.
> 
> If you have some idea ,please suggest how to reproduce it.

You could try enabling lockdep and see if it catches anything earlier
on.

Will

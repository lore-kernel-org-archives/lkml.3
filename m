Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab3E1KS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:18:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55971 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab3E1KS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:18:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130517155936.GQ23112@mudshark.cambridge.arm.com>
References: <CACVXFVPjo2dQpYPpqZS8GC8UPNzB5HLURpYm6-g1FOBbSUjDyA@mail.gmail.com>
	<20130517085530.GB22992@mudshark.cambridge.arm.com>
	<CACVXFVPEBXat3bPPuHzV535=xLoRMFd03Kjzp=NUF5E3KCq2=g@mail.gmail.com>
	<20130517093616.GC23112@mudshark.cambridge.arm.com>
	<CACVXFVP56EJb0BZ+w6hVAukQ-mN0e0Jn_GLw3XqXQqMwVGfNdA@mail.gmail.com>
	<20130517095423.GD23112@mudshark.cambridge.arm.com>
	<CACVXFVPJyKrOBk+JjsfCi+aQ8snQ7PsEJVuOnuTkrWBYEnvDtA@mail.gmail.com>
	<20130517155936.GQ23112@mudshark.cambridge.arm.com>
Date: Tue, 28 May 2013 18:18:53 +0800
Message-ID: <CACVXFVM6Yn99HeNknG3GybuM=_PWchqa2dNKcv=j+fiib0z4ug@mail.gmail.com>
Subject: Re: [Bug] ARM 'perf' regression by commit a43cb95d5
From: Ming Lei <ming.lei@canonical.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 11:59 PM, Will Deacon <will.deacon@arm.com> wrote:
>
> Ok, I tried to reproduce this on my TC2 with 3.10-rc1 and perf top looks
> fine. I also tried loading your spi-altera module and it made no difference.
>
> I'm using a fairly old perf tool (reports its version as 3.5.5).

It isn't related with perf tool.

Finally, looks the problem disappeared after upgrading gcc to "gcc version
4.7.3 (Sourcery CodeBench Lite 2013.05-24)" from "gcc version 4.5.1
(Sourcery G++ Lite 2010.09-50)", so it should be caused by compiler.


Thanks,
--
Ming Lei

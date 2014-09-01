Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaIAUOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 16:14:34 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:52488 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaIAUOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 16:14:33 -0400
Date: Mon, 1 Sep 2014 22:14:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Dave Jones <davej@redhat.com>, Catalin Iacob <iacobcatalin@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: nohz fail (was: perf related boot hang.)
Message-ID: <20140901201429.GA1586@lerouge>
References: <20140811200931.GA18865@redhat.com>
 <1408566691-3023-1-git-send-email-iacobcatalin@gmail.com>
 <CAFTL4hxJ2roTB3tZBmXU3HRetgFSUT0LNVWfX-Y2hbpyXSo2pg@mail.gmail.com>
 <CAHg_5gq1XiZ1A08PtQ7Rof3rUXJ-pVYkXtmHqgFh6hB+++qPNg@mail.gmail.com>
 <20140822140009.GA8567@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822140009.GA8567@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 10:00:09AM -0400, Dave Jones wrote:
> On Fri, Aug 22, 2014 at 08:01:48AM +0200, Catalin Iacob wrote:
>  > On Thu, Aug 21, 2014 at 4:56 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>  > > Can you please test the series I just posted: "[RFC PATCH 0/9] nohz:
>  > > Nohz full kick fixes"?
>  > 
>  > Before applying the series I tried one more Firefox build which
>  > triggered the panic after less than 5 minutes.
>  > 
>  > After applying the series I did 2 full builds (around 60 minutes in
>  > total) with no problem.
> 
> Seems to be working fine here too after fuzzing for 17 hours so far.

Thanks a lot for testing this guys!

I'll send "nohz: Restore NMI safe local irq work for local nohz kick"
as a fix for 3.17 and the rest will have to wait for 3.18 as it's a complicated
fix for a long standing bug.

Can I apply your Tested-by from you both?

Thanks.

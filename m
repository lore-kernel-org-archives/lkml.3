Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3HEIVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:21:25 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:46452 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab3HEIVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:21:23 -0400
Date: Mon, 5 Aug 2013 10:21:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: stable: please queue commit 0231bb5 ("perf: Fix event group
 context move")
Message-ID: <20130805082118.GD26746@gmail.com>
References: <51FF5FC9.8080302@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FF5FC9.8080302@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizefan@huawei.com> wrote:

> Plese consider adding commit 0231bb5336758426b44ccd798ccd3c5419c95d58
> to stable tree. It fixes a real bug, which was explained here:
> 
> 	http://thread.gmane.org/gmane.linux.kernel.perf.user/1144
> 
> and I've managed to reproduce the bug in 3.4 kernel with the test
> program attached in the above email, and I've confirmed the bug fix.
> 
> The effect of the bug is, if we open a group of mixed events(sw/hw)
> and the "disabled" flag is not set and sw events come first, then
> some of the perf events won't be started after the call to perf_event_open().
> 
> The bug fix should be applicable to kernels >= 3.0 && <= 3.7.

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo

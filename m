Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab3H1B1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 21:27:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab3H1B1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 21:27:19 -0400
Date: Tue, 27 Aug 2013 18:26:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        voice.shen@atmel.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: mmotm 2013-08-27-16-51 uploaded
Message-Id: <20130827182616.f9396ed6.akpm@linux-foundation.org>
In-Reply-To: <521D494F.1010507@codeaurora.org>
References: <20130827235227.99DB95A41D6@corp2gmr1-2.hot.corp.google.com>
	<521D494F.1010507@codeaurora.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013 17:50:23 -0700 Stephen Boyd <sboyd@codeaurora.org> wrote:

> On 08/27/13 16:52, akpm@linux-foundation.org wrote:
> > * kernel-time-sched_clockc-correct-the-comparison-parameter-of-mhz.patch
> >
> 
> I believe Russell nacked this change[1]? This should probably be dropped
> unless there's been more discussion. Or maybe reworked into a comment in
> the code that doesn't lead to the same change again.
> 
> [1] https://lkml.org/lkml/2013/8/7/95

Well OK, but the code looks totally wrong.  Care to send a comment patch
so the next confused person doesn't "fix" it?

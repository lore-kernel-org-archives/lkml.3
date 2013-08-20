Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab3HTWq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 18:46:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3HTWq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 18:46:58 -0400
Date: Tue, 20 Aug 2013 15:46:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
Message-Id: <20130820154656.c30c1fa6da56997cd1bd3b86@linux-foundation.org>
In-Reply-To: <20130820130056.GA9652@infradead.org>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
	<20130820130056.GA9652@infradead.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013 06:00:56 -0700 Christoph Hellwig <hch@infradead.org> wrote:

> As I've seen very few replies to this:  how do we ensure this gets
> picked up for the 3.12 merge window?  The series has been a reposted
> a few times without complaints or major changes,

That's probably a sign that nobody bothered reading it all :( The
smattering of acks in there is not encouraging.

Please add Sedat's Tested-by (thanks!)

Please add performance test results.

Mel, do you have any swap-over-nfs test cases which should be performed?

Dave, what sort of correctness/robustness tests have you been running?

Yes, I guess it's not a bad idea to get this into -next, but it does
seem to have been pretty low-profile...

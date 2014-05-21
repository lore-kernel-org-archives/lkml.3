Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaEUKrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:47:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:39221 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaEUKrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:47:49 -0400
Date: Wed, 21 May 2014 12:47:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <dongsheng081251@gmail.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix tracepoint in scheduler.
Message-ID: <20140521104746.GB2485@laptop.programming.kicks-ass.net>
References: <1396527168-3929-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <20140404125249.GC10526@twins.programming.kicks-ass.net>
 <CA+qeAOp5G94n5d1wOGe876d1HkSTVxN9hVbr9jLhGmSGvsAtJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+qeAOp5G94n5d1wOGe876d1HkSTVxN9hVbr9jLhGmSGvsAtJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 06:03:53PM +0800, Dongsheng Yang wrote:
> Hi Peter, did you forget to take this patch? :-)

No, I skipped it on purpose, its useful to be able to see if code tries
to do superfluous migrations.

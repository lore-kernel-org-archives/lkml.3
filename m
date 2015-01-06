Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbbAFMKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:10:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbbAFMKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:10:13 -0500
Date: Tue, 6 Jan 2015 20:08:11 +0800
From: Baoquan He <bhe@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <waiman.long@hp.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] locking/rwlocks: clean up of qrwlock
Message-ID: <20150106120811.GA5965@dhcp-16-105.nay.redhat.com>
References: <1418709640-5625-1-git-send-email-bhe@redhat.com>
 <20141216090128.GU3337@twins.programming.kicks-ass.net>
 <20141216153650.GA1758@dhcp-17-102.nay.redhat.com>
 <5491F2AC.7000103@hp.com>
 <20150106092542.GB2726@dhcp-16-105.nay.redhat.com>
 <20150106101311.GM29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106101311.GM29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/15 at 11:13am, Peter Zijlstra wrote:
> On Tue, Jan 06, 2015 at 05:25:42PM +0800, Baoquan He wrote:
> > Hi all,
> > 
> > Thanks for reviewing. 
> > 
> > Do you have any other concerns about this small change?
> 
> I just don't see any point in making the code worse for the 1 arch that
> actually uses it. If there were other archs using it and for them the
> code generation would be negatively impacted (they'd actually generate
> more core because of it) it might be worth looking at.

Hi Peter,

It's OK if you don't like it. I am just a little confused about 2
things:

1) Waiman said "- _QR_BIAS" is used to simulate the xaddr which is only
in x86. So removing it to make it be consistent with other ARCHs, why is
it not good? And you said making the code worse, could you be more
specific?

2) Previously you said this change will make it bigger, I thought you
means the cnts. Am I correct? Or you mean other thing? 

Just want to understand it clearly, please point out what's wrong about
my understanding.



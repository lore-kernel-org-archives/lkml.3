Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbbAFKN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:13:28 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:59704 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbbAFKN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:13:26 -0500
Date: Tue, 6 Jan 2015 11:13:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Baoquan He <bhe@redhat.com>
Cc: Waiman Long <waiman.long@hp.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] locking/rwlocks: clean up of qrwlock
Message-ID: <20150106101311.GM29390@twins.programming.kicks-ass.net>
References: <1418709640-5625-1-git-send-email-bhe@redhat.com>
 <20141216090128.GU3337@twins.programming.kicks-ass.net>
 <20141216153650.GA1758@dhcp-17-102.nay.redhat.com>
 <5491F2AC.7000103@hp.com>
 <20150106092542.GB2726@dhcp-16-105.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106092542.GB2726@dhcp-16-105.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 05:25:42PM +0800, Baoquan He wrote:
> Hi all,
> 
> Thanks for reviewing. 
> 
> Do you have any other concerns about this small change?

I just don't see any point in making the code worse for the 1 arch that
actually uses it. If there were other archs using it and for them the
code generation would be negatively impacted (they'd actually generate
more core because of it) it might be worth looking at.

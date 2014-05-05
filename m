Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaEEQbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 12:31:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34935 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbaEEQbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 12:31:35 -0400
Date: Mon, 5 May 2014 18:31:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: mingo@kernel.org, linux-tip-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peter@hurleysoftware.com, jason.low2@hp.com, riel@redhat.com,
        alex.shi@linaro.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de, walken@google.com,
        davidlohr@hp.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [tip:locking/core] rwsem: Add comments to explain the meaning of
 the rwsem's count field
Message-ID: <20140505163122.GT26782@laptop.programming.kicks-ass.net>
References: <1399060437.2970.146.camel@schen9-DESK>
 <tip-3cf2f34e1a3d4d5ff209d087925cf950e52f4805@git.kernel.org>
 <1399305808.2970.186.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1399305808.2970.186.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 09:03:28AM -0700, Tim Chen wrote:
> On Mon, 2014-05-05 at 01:46 -0700, tip-bot for Tim Chen wrote:
> > Commit-ID:  3cf2f34e1a3d4d5ff209d087925cf950e52f4805
> > Gitweb:     http://git.kernel.org/tip/3cf2f34e1a3d4d5ff209d087925cf950e52f4805
> > Author:     Tim Chen <tim.c.chen@linux.intel.com>
> > AuthorDate: Fri, 2 May 2014 12:53:57 -0700
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Sun, 4 May 2014 20:34:26 +0200
> > 
> 
> Ingo,
> 
> Can you pick up this version of the patch instead.  I've updated the
> comments to reflect all cases for which the rwsem's count is less than
> WAITING_BIAS, as Peter has pointed out.

Wouldn't a state diagram be clearer than this gobs of text?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaKDT6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:58:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbaKDT6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:58:08 -0500
Date: Tue, 4 Nov 2014 13:57:56 -0600
From: David Teigland <teigland@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Joe Perches <joe@perches.com>,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com
Subject: Re: [RFA][PATCH 5/8] dlm: Remove seq_printf() return checks and use
 seq_has_overflowed()
Message-ID: <20141104195756.GA10616@redhat.com>
References: <20141029215602.535533597@goodmis.org>
 <20141029220107.939492048@goodmis.org>
 <20141104080852.4c666fbe@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104080852.4c666fbe@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 08:08:52AM -0500, Steven Rostedt wrote:
> On Wed, 29 Oct 2014 17:56:07 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Joe Perches <joe@perches.com>
> > 
> > [ REQUEST FOR ACKS ]
> 
> Can any of the DLM maintainers give me an Acked-by for this?

Looks ok,
Dave


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaKERu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:50:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44439 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaKERuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:50:25 -0500
Date: Wed, 5 Nov 2014 17:50:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [RFA][PATCH 0/8] seq_file: Remove return checks of seq_printf()
Message-ID: <20141105175020.GA3895@ZenIV.linux.org.uk>
References: <20141029215602.535533597@goodmis.org>
 <20141104080436.10904a7a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104080436.10904a7a@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 08:04:36AM -0500, Steven Rostedt wrote:
> On Wed, 29 Oct 2014 17:56:02 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > [ REQUEST FOR ACKS ]
> 
> Al,
> 
> Can you take a look at these, and give me an Acked-by if they are OK
> with you?

Looks sane.  How do you want to handle the merge of that series?

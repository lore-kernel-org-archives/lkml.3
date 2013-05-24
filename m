Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab3EXW3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 18:29:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3EXW3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 18:29:46 -0400
Date: Fri, 24 May 2013 15:29:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] ipc: move locking out of ipcctl_pre_down_nolock
Message-Id: <20130524152945.e62c2477670c20c5cef57759@linux-foundation.org>
In-Reply-To: <1369434096.2138.24.camel@buesod1.americas.hpqcorp.net>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
	<1368666490-29055-5-git-send-email-davidlohr.bueso@hp.com>
	<20130524131652.e21bff6b6c6a214b19b299a9@linux-foundation.org>
	<1369434096.2138.24.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May 2013 15:21:36 -0700 Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:

> > 
> > Where should readers go to understand the overall locking scheme?  A
> > description of the overall object hierarchy and the role which the
> > various locks play?
> 
> That can be done, how about something like
> Documentation/ipc-locking.txt?

I find that code comments at definition sites work better, if possible.
Standalone documentation ends up being too verbose and never gets
updated or read...


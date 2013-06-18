Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab3FRU1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 16:27:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab3FRU1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:27:07 -0400
Date: Tue, 18 Jun 2013 13:27:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] hugetlb fixes
Message-Id: <20130618132705.c5eb78a20499beb1b769f741@linux-foundation.org>
In-Reply-To: <20130618185055.GA27618@logfs.org>
References: <1371581225-27535-1-git-send-email-joern@logfs.org>
	<20130618185055.GA27618@logfs.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013 14:50:55 -0400 J__rn Engel <joern@logfs.org> wrote:

> On Tue, 18 June 2013 14:47:03 -0400, Joern Engel wrote:
> > 
> > Test program below is failing before these two patches and passing
> > after.
> 
> Actually, do we have a place to stuff kernel tests?  And if not,
> should we have one?

Yep, tools/testing/selftests/vm.  It's pretty simple and stupid at
present - it anything about the framework irritates you, please fix it!

General guidelines for tools/testing/selftests: the tool should execute
quickly and shouldn't break the overall selftests run at either compile
time or runtime if kernel features are absent, Kconfig is unexpected,
etc.

It's more a "place to accumulate and maintain selftest programs" than a
serious self-testing framework.


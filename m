Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab3EPSMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:12:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59708 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab3EPSMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:12:03 -0400
Date: Thu, 16 May 2013 20:10:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, gleb@redhat.com,
        Robert Richter <rric@kernel.org>
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130516181018.GO19669@dyad.programming.kicks-ass.net>
References: <20130516151026.GB18325@hansolo.jdub.homelinux.org>
 <20130516175117.GK19669@dyad.programming.kicks-ass.net>
 <20130516175557.GC18325@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516175557.GC18325@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 01:55:57PM -0400, Josh Boyer wrote:
> Maybe.  But do you really need to dump a stack trace here?  What is a
> user supposed to do with that information?  Can they fix the kernel?
> Can the fix the CPU?  As far as I can tell, they can't do either.

Send their CPU back to AMD is I suppose the best they can do ;-)
 
> Is using pr_err with the same message really somehow worse than using
> WARN?

I would make it a FW_BUG as well. But yeah, I suppose that is a better option
than the WARN_ON. Unless Robert had a different reason...


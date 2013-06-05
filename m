Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab3FELBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:01:14 -0400
Received: from 1wt.eu ([62.212.114.60]:36022 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab3FELBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:01:09 -0400
Date: Wed, 5 Jun 2013 13:01:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        John Johansen <john.johansen@canonical.com>
Subject: Re: [ 020/184] ptrace: ensure arch_ptrace/ptrace_request can never
Message-ID: <20130605110100.GA27897@1wt.eu>
References: <20130604172131.136042108@1wt.eu> <87sj0wucft.fsf@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sj0wucft.fsf@canonical.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:36:06AM +0100, Luis Henriques wrote:
> Willy Tarreau <w@1wt.eu> writes:
> 
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >  race with SIGKILL
> >
> > From: Oleg Nesterov <oleg@redhat.com>
> >
> > ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL
> >
> 
> This patch actually introduce a regression in the Ubuntu kernel.  You
> may want to include the fix below.
> 
> http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-lucid.git;a=commit;h=d06bbd59e5c7a0e0525af764a897028d6d352c36

Thanks for letting me know, Luis. Queuing it now.

Willy


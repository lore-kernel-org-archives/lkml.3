Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab3BFVr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:47:27 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64383 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454Ab3BFVrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:47:24 -0500
Date: Wed, 6 Feb 2013 22:47:20 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Shi <alex.shi@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rwsem: steal writing sem for better performance
Message-ID: <20130206214720.GB28135@gmail.com>
References: <1360069915-31619-1-git-send-email-alex.shi@intel.com>
 <20130205145854.GA30949@gmail.com>
 <51119ED0.3030207@intel.com>
 <20130206112811.GD8696@gmail.com>
 <CA+55aFwFCXGE9zTOOqGzC5wBDk+KjBZvqDpiiFYcVSsbv0ThPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwFCXGE9zTOOqGzC5wBDk+KjBZvqDpiiFYcVSsbv0ThPQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Feb 6, 2013 at 10:28 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Linus, Andrew, what is your thinking about the patch and about
> > the timing of the patch?
> 
> Not for 3.8. Queue it for 3.9, with possibly a stable tag with 
> a big comment "apply after much testing".

Ok, will do!

Thanks,

	Ingo

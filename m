Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaC1Qzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 12:55:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:1750 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbaC1Qzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 12:55:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,751,1389772800"; 
   d="scan'208";a="482238823"
From: Andi Kleen <andi@firstfloor.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] tracing: Add 'hash' event trigger command
References: <cover.1395894625.git.tom.zanussi@linux.intel.com>
	<b81b0860d2915c0b562863fce889249dad080922.1395894625.git.tom.zanussi@linux.intel.com>
Date: Fri, 28 Mar 2014 09:54:55 -0700
In-Reply-To: <b81b0860d2915c0b562863fce889249dad080922.1395894625.git.tom.zanussi@linux.intel.com>
	(Tom Zanussi's message of "Wed, 26 Mar 2014 23:54:07 -0500")
Message-ID: <87lhvunu00.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Zanussi <tom.zanussi@linux.intel.com> writes:

> Hash triggers allow users to continually hash events which can then be
> dumped later by simply reading the trigger file.  This is done
> strictly via one-liners and without any kind of programming language.

I read through the whole thing. I think I got it somewhere near the end,
but it was quite difficult. What really confuses me is your
use of the "hash" term. I believe the established term for these
kind of data operations is "histogram". How about calling it that.

Overall it seems useful, but it's not fully clear to me why it needs
to be done in the kernel and not an analysis tool?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

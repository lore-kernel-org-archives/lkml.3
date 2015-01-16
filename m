Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbbAPBhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:37:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbbAPBhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:37:01 -0500
Date: Fri, 16 Jan 2015 09:36:48 +0800
From: Fam Zheng <famz@redhat.com>
To: Jason Baron <jbaron@akamai.com>
Cc: akpm@linux-foundation.org, normalperson@yhbt.net, nzimmer@sgi.com,
        viro@zeniv.linux.org.uk, davidel@xmailserver.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Remove global locks from epoll
Message-ID: <20150116013648.GC3079@ad.nay.redhat.com>
References: <cover.1421337657.git.jbaron@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1421337657.git.jbaron@akamai.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01/15 21:02, Jason Baron wrote:
> Finally, I'd also like to potentially co-ordinate this series with the recent
> syscall enhancements from Fam Zheng: http://lwn.net/Articles/628828/ since these
> patches are somewhat invasive.

What I am working on is a new call that can be seen as a list of epoll_ctl
operations followed by an wait, which has enriched clockid and timespec
flexibility. it will reuse existing calls' implementation, but that ideally
should be independent to most of the implementation internals, including
locking changes here.

Thanks for letting me know!

Fam

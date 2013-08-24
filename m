Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3HXPZf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 11:25:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40600 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3HXPZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 11:25:34 -0400
Date: Sat, 24 Aug 2013 16:25:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: kill the extra
 proc_readfd_common()->dir_emit_dots()
Message-ID: <20130824152525.GU27005@ZenIV.linux.org.uk>
References: <20130824151434.GA28775@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130824151434.GA28775@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 05:14:34PM +0200, Oleg Nesterov wrote:
> proc_readfd_common() does dir_emit_dots() twice in a row,
> we need to do this only once.

I really wonder how that one had happened - it's harmless, fortunately,
but...  Ugh.  Applied, will push to Linus today

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab3BTWbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:31:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab3BTWbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:31:40 -0500
Date: Wed, 20 Feb 2013 23:30:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3] lockdep: check that no locks held at freeze time
Message-ID: <20130220223013.GA15760@redhat.com>
References: <20130216170605.GC4910@redhat.com> <1361325468-7998-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361325468-7998-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Mandeep Singh Baines wrote:
>
> We shouldn't try_to_freeze if locks are held. Verified that
> I get no lockdep warnings after applying this patch and
> "vfork: don't freezer_count() for in-kernel users of CLONE_VFORK".

I believe the patch is fine.

But I don't understand the changelog, unless I am totally confused
(and I have a lot of unread emails so perhaps I missed something),
this version do not need the changes in CLONE_VFORK.

And, Mandeep, I'll try to answer your emails asap...

Oleg.


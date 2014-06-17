Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbaFQXWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 19:22:09 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:63484 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376AbaFQXWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 19:22:07 -0400
Date: Tue, 17 Jun 2014 19:22:02 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET percpu/for-3.17] percpu: clean up percpu accessor and
 operation definitions
Message-ID: <20140617232202.GD8838@mtj.dyndns.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402590209-31610-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 12, 2014 at 12:23:17PM -0400, Tejun Heo wrote:
> Percpu accessor and operation definitions are very difficult to
> follow.  Things are scattered around different header files without
> specific reasons.  Definitions of different types are mixed and the
> ordering sometimes is conventional.  Different definitions use
> different styles and sometimes lack visual consistency for no good
> reason.
...
> This patchset is on top of
> 
>   linus master c31c24b8251f ("Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux")
> + [1] [PATCH RFC] percpu: add data dependency barrier in percpu accessors and operations

Omitted the data dependency barrier and applied the series to
percpu/for-3.17.

Thanks.

-- 
tejun

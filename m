Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab3AYR2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:28:11 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35406 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab3AYR2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:28:09 -0500
Date: Fri, 25 Jan 2013 09:28:05 -0800
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for
 multimedia devices
Message-ID: <20130125172805.GG3081@htj.dyndns.org>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
 <1359039649-17734-7-git-send-email-pbonzini@redhat.com>
 <20130124225555.GC2373@mtj.dyndns.org>
 <51024FB1.3000206@redhat.com>
 <20130125170434.GC3081@htj.dyndns.org>
 <5102BDD4.2020501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5102BDD4.2020501@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 06:16:04PM +0100, Paolo Bonzini wrote:
> Well, you can find broken devices for pretty much every command in the
> list.  Anyhow, the other two commands are obsolete so I'm okay with
> leaving them out, if only for the sake of avoiding useless email threads.

Once we open the commands to userland this way, it's difficult to
throttle it back again.  I just fail to see the point of allowing
everything possible.  There's a way to override it (is that in yet?)
and we can always extend the list later, so please do the minimal set
with justification and can you please stop labeling reviews as
"useless"?  For Pete's sake, if you disagree, just disagree and
explain your point.  How is discussion about which commands should be
allowed via SG_IO "useless"?  Gees...

-- 
tejun

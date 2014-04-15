Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaDOXRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:17:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41436 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaDOXRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:17:47 -0400
Date: Tue, 15 Apr 2014 19:17:43 -0400 (EDT)
Message-Id: <20140415.191743.963157803966994138.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ast@plumgrid.com, eparis@redhat.com, james.l.morris@oracle.com,
        keescook@chromium.org
Subject: Re: [PATCH] seccomp: fix populating a0-a5 syscall args in 32-bit
 x86 BPF
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFy2hDuadQK=09JiEL9wxLD4OLiODiSzhsydwfP9jkFMpQ@mail.gmail.com>
References: <1397502179-15029-1-git-send-email-dborkman@redhat.com>
	<CA+55aFy2hDuadQK=09JiEL9wxLD4OLiODiSzhsydwfP9jkFMpQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Apr 2014 16:17:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Apr 2014 15:52:42 -0700

> [ Sorry for delayed testing, I just came back home and didn't have
> access to the affected 32-bit machine on the road ]
> 
> On Mon, Apr 14, 2014 at 12:02 PM, Daniel Borkmann <dborkman@redhat.com> wrote:
>> Linus reports that on 32-bit x86 Chromium throws the following seccomp
>> resp. audit log messages:
> 
> Tested, and fixes the problem for me.

I'll push this fix to you later this evening.

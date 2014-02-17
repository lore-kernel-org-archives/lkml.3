Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbaBQWb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:31:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbaBQWb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:31:27 -0500
Message-ID: <53028DB0.6000501@redhat.com>
Date: Mon, 17 Feb 2014 23:31:12 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mcree@orcon.net.nz, mattst88@gmail.com,
        mathieu.desnoyers@efficios.com, jay.estabrook@gmail.com
Subject: Re: [PATCH] csum_partial_copy_from_user: clean up inconsistencies
 in implementations
References: <alpine.LRH.2.02.1402151044010.25662@file01.intranet.prod.int.rdu2.redhat.com> <20140217.162105.899153264722449005.davem@davemloft.net> <alpine.LRH.2.02.1402171714030.21254@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1402171714030.21254@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 11:20 PM, Mikulas Patocka wrote:
...
>> The proper way to add commentary is to put it after the "---" delimiter
>> at the end of the commit message and before the actual patch.
>
> Interesting - I used "---" as a delimiter between the commentary and the
> git message in the past and some people said that their patch parser can't
> detect "---" and that I should use "From:" line as a delimiter. And now I
> see that your patch parser doesn't detect "From:" and needs "---".

It's simple: Documentation/SubmittingPatches +582  says ...

The "---" marker line serves the essential purpose of marking for patch
handling tools where the changelog message ends.

One good use for the additional comments after the "---" marker is for
a diffstat, to show what files have changed, and the number of
inserted and deleted lines per file.  A diffstat is especially useful
on bigger patches.  Other comments relevant only to the moment or the
maintainer, not suitable for the permanent changelog, should also go
here.  A good example of such comments might be "patch changelogs"
which describe what has changed between the v1 and v2 version of the
patch.

So, between "---" and the diffstat you could have put your comment.
That's what the official document says in that regard. ;)

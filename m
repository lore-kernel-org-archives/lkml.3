Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbaDVUJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:09:22 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:34677 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaDVUJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:09:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140422.160558.627080587952506099.davem@davemloft.net>
References: <1397596546-10153-1-git-send-email-vgoyal@redhat.com> <20140422.160558.627080587952506099.davem@davemloft.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 22 Apr 2014 13:08:59 -0700
Message-ID: <CALCETrWHA5ZmzOHnz9LO+7v4byc8QiynGyjE_ju5sjokNqrjZA@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: Implement SO_PEERCGROUP and SO_PASSCGROUP socket options
To: David Miller <davem@davemloft.net>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Simo Sorce <ssorce@redhat.com>,
        lpoetter@redhat.com, kay@redhat.com, Daniel Walsh <dwalsh@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 1:05 PM, David Miller <davem@davemloft.net> wrote:
> From: Vivek Goyal <vgoyal@redhat.com>
> Date: Tue, 15 Apr 2014 17:15:44 -0400
>
>> This is another version of patchset to add support passing cgroup
>> information of client over unix socket API.
>
> I'm marking this patch series as "changes requested" in patchwork
> because if we still end up adding this feature SO_PASSCGROUP needs to
> be changed to behave like SO_PASSCRED.
>
> Specifically, like SO_PASSCRED, it should pass the "real" cgroup, ie.
> the cgroup at socket open() time.
>

I suspect that making this change will render it useless,
unfortunately.  I really want to understand the use case.

--Andy

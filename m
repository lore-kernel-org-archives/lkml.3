Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbaDVUGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:06:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43260 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaDVUGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:06:00 -0400
Date: Tue, 22 Apr 2014 16:05:58 -0400 (EDT)
Message-Id: <20140422.160558.627080587952506099.davem@davemloft.net>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, tj@kernel.org, ssorce@redhat.com,
        lpoetter@redhat.com, kay@redhat.com, luto@amacapital.net,
        dwalsh@redhat.com
Subject: Re: [PATCH 0/2] net: Implement SO_PEERCGROUP and SO_PASSCGROUP
 socket options
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397596546-10153-1-git-send-email-vgoyal@redhat.com>
References: <1397596546-10153-1-git-send-email-vgoyal@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 22 Apr 2014 13:06:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 15 Apr 2014 17:15:44 -0400

> This is another version of patchset to add support passing cgroup
> information of client over unix socket API.

I'm marking this patch series as "changes requested" in patchwork
because if we still end up adding this feature SO_PASSCGROUP needs to
be changed to behave like SO_PASSCRED.

Specifically, like SO_PASSCRED, it should pass the "real" cgroup, ie.
the cgroup at socket open() time.

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3HBVvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:51:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42173 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab3HBVvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:51:47 -0400
Date: Fri, 02 Aug 2013 14:51:46 -0700 (PDT)
Message-Id: <20130802.145146.215059840395396296.davem@davemloft.net>
To: pmoore@redhat.com
Cc: amwang@redhat.com, netdev@vger.kernel.org, james.l.morris@oracle.com,
        sds@tycho.nsa.gov, eparis@parisplace.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [Patch net-next v2 8/8] selinux: use generic union inet_addr
From: David Miller <davem@davemloft.net>
In-Reply-To: <4528870.px4VD3WrY3@sifl>
References: <1375427674-21735-1-git-send-email-amwang@redhat.com>
	<1375427674-21735-9-git-send-email-amwang@redhat.com>
	<4528870.px4VD3WrY3@sifl>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 02 Aug 2013 14:51:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <pmoore@redhat.com>
Date: Fri, 02 Aug 2013 10:34:07 -0400

> On Friday, August 02, 2013 03:14:34 PM Cong Wang wrote:
>> From: Cong Wang <amwang@redhat.com>
>> 
>> selinux has some similar definition like union inet_addr,
>> it can re-use the generic union inet_addr too.
>> 
>> Cc: James Morris <james.l.morris@oracle.com>
>> Cc: Stephen Smalley <sds@tycho.nsa.gov>
>> Cc: Eric Paris <eparis@parisplace.org>
>> Cc: Paul Moore <pmoore@redhat.com>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-security-module@vger.kernel.org
>> Signed-off-by: Cong Wang <amwang@redhat.com>
> 
> Perhaps I'm confusing this with another patch but I though DaveM said he 
> wasn't going to merge these patches?

I didn't like how he added completely unused bloat to various
datastructures because he unconditionally put a port field into
there.

He removed that problem this time, but there are still a lot of
things I don't like about this patch series.

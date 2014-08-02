Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbaHBWKd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 18:10:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49531 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbaHBWK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 18:10:26 -0400
Date: Sat, 02 Aug 2014 15:10:24 -0700 (PDT)
Message-Id: <20140802.151024.636036304502082388.davem@davemloft.net>
To: ast@plumgrid.com
Cc: pablo@netfilter.org, dborkman@redhat.com, willemb@google.com,
        keescook@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 5/5] net: filter: split 'struct sk_filter'
 into socket and bpf parts
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMEtUuxDSGysNKr12qYQAXjmb4qP45trh3qVx41W7WVduPS5zw@mail.gmail.com>
References: <CAMEtUuympZm+qVOc+4MJoSnAwSZ-Gx=tSOaHwudtP7Q92eHAtw@mail.gmail.com>
	<20140801190341.GA28642@salvia>
	<CAMEtUuxDSGysNKr12qYQAXjmb4qP45trh3qVx41W7WVduPS5zw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 Aug 2014 15:10:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Fri, 1 Aug 2014 12:12:36 -0700

> Dave, this patch has trivial conflict with Daniel's
> ("team: fix releasing uninitialized pointer to BPF prog") fix.
> Let me know if you want me to respin the series or you'll patch up
> the conflict yourself.

I took care of this, it was easy to resolve.

Thanks.

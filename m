Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab3DYFt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 01:49:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48490 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3DYFt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 01:49:27 -0400
Date: Thu, 25 Apr 2013 01:49:25 -0400 (EDT)
Message-Id: <20130425.014925.207045396378265668.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, hkchu@google.com,
        weiyj.lk@gmail.com, edumazet@google.com
Subject: Re: [PATCH net] tuntap: correct the return value in tun_set_iff()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1366699239-6866-1-git-send-email-jasowang@redhat.com>
References: <1366699239-6866-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 24 Apr 2013 22:49:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Tue, 23 Apr 2013 14:40:39 +0800

> commit (3be8fbab tuntap: fix error return code in tun_set_iff()) breaks the
> creation of multiqueue tuntap since it forbids to create more than one queues
> for a multiqueue tuntap device. We need return 0 instead -EBUSY here since we
> don't want to re-initialize the device when one or more queues has been already
> attached. Add a comment and correct the return value to zero.
> 
> Reported-by: Jerry Chu <hkchu@google.com>
> Cc: Jerry Chu <hkchu@google.com>
> Cc: Wei Yongjun <weiyj.lk@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied.

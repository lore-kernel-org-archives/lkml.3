Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbaGHWQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:16:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54640 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaGHWQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:16:10 -0400
Date: Tue, 08 Jul 2014 15:16:09 -0700 (PDT)
Message-Id: <20140708.151609.2007775439986953108.davem@davemloft.net>
To: decot@googlers.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, edumazet@google.com, amwang@redhat.com,
        antonio@meshcoding.com, jpirko@redhat.com
Subject: Re: [PATCH net-next v1 2/2] netpoll: avoid reference leaks
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAG88wWa9WTz4gwLHWAys1e96eWBgD+mcVW=hPh7a+b2ooJzBeQ@mail.gmail.com>
References: <CAG88wWZ9GiqoOscqG4-ePOWo8bXgSTAQ6=6-tZPahMcxOvQMLg@mail.gmail.com>
	<20140708.141708.2064358397103630362.davem@davemloft.net>
	<CAG88wWa9WTz4gwLHWAys1e96eWBgD+mcVW=hPh7a+b2ooJzBeQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 15:16:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@googlers.com>
Date: Tue, 8 Jul 2014 14:50:24 -0700

> In that case, that's what the original code does: dropping this patch 2/2.
> 
> Patch 1/2 "netpoll: fix use after free" is still needed to prevent
> panics, though.

Please resubmit it then.

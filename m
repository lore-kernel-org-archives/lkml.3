Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbaIDVtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:49:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41620 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068AbaIDVtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:49:17 -0400
Date: Thu, 04 Sep 2014 14:49:15 -0700 (PDT)
Message-Id: <20140904.144915.2011704191141142761.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, torvalds@linux-foundation.org, luto@amacapital.net,
        rostedt@goodmis.org, hannes@stressinduktion.org, chema@google.com,
        edumazet@google.com, a.p.zijlstra@chello.nl, hpa@zytor.com,
        akpm@linux-foundation.org, keescook@chromium.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dborkman@redhat.com
Subject: Re: [PATCH v9 net-next 2/4] net: filter: split filter.h and expose
 eBPF to user space
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMEtUuz6zraph_8xXW43bNbh5uPRki0yOufMfV5pKMRLhDrQQA@mail.gmail.com>
References: <CAMEtUuz6zraph_8xXW43bNbh5uPRki0yOufMfV5pKMRLhDrQQA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Sep 2014 14:49:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Wed, 3 Sep 2014 22:41:48 -0700

> Do you want me to resubmit just first two?

Yes, you can't submit hodge-podge path series, either it's all to
be applied or it's all RFC material.

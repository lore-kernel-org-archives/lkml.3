Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbaFYXEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 19:04:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39001 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbaFYXEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 19:04:34 -0400
Date: Wed, 25 Jun 2014 16:04:33 -0700 (PDT)
Message-Id: <20140625.160433.1012876682294424845.davem@davemloft.net>
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux@horizon.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] crc32 combine improvements
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403529116-18385-1-git-send-email-dborkman@redhat.com>
References: <1403529116-18385-1-git-send-email-dborkman@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Jun 2014 16:04:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 23 Jun 2014 15:11:53 +0200

> So almost a month passed, and I don't want this to get lost
> somewhere. I have applied the feedback given at that time to
> this set, rebased plus tested it against latest net-next. I
> decided to route this via netdev as it improves performance
> upon library code that provides library bits for SCTP, i.e.
> for non-linear skb csum handling in IPVS. Thus, resending
> this for George before it gets lost.

Series applied, thanks Daniel.

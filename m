Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab3G3Tzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 15:55:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40993 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab3G3Tzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 15:55:43 -0400
Date: Tue, 30 Jul 2013 12:55:42 -0700 (PDT)
Message-Id: <20130730.125542.2060050812919169911.davem@davemloft.net>
To: mst@redhat.com
Cc: jasowang@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V2 2/2] macvtap: do not zerocopy if iov needs more
 pages than MAX_SKB_FRAGS
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130730114125.GB22218@redhat.com>
References: <1374116116-43844-2-git-send-email-jasowang@redhat.com>
	<20130719050351.GB8537@redhat.com>
	<20130730114125.GB22218@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Jul 2013 12:55:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 30 Jul 2013 14:41:25 +0300

> Was this patch dropped?

Nope, it's commit ece793fcfc417b3925844be88a6a6dc82ae8f7c6

> Any objections to merging it for 3.11 and stable?

No objection, queued up for -stable.

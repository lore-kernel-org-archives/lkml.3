Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaCLDXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 23:23:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33177 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbaCLDXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 23:23:33 -0400
Date: Tue, 11 Mar 2014 23:23:31 -0400 (EDT)
Message-Id: <20140311.232331.953854418721439734.davem@davemloft.net>
To: linus.luessing@web.de
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        jstancek@redhat.com, fwestpha@redhat.com
Subject: Re: [PATCHv2 2/2] bridge: multicast: enable snooping on general
 queries only
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394486725-4992-2-git-send-email-linus.luessing@web.de>
References: <1394486725-4992-1-git-send-email-linus.luessing@web.de>
	<1394486725-4992-2-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Mar 2014 20:23:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Mon, 10 Mar 2014 22:25:25 +0100

> Without this check someone could easily create a denial of service
> by injecting multicast-specific queries to enable the bridge
> snooping part if no real querier issuing periodic general queries
> is present on the link which would result in the bridge wrongly
> shutting down ports for multicast traffic as the bridge did not learn
> about these listeners.
> 
> With this patch the snooping code is enabled upon receiving valid,
> general queries only.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@web.de>

Applied.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbaKXUPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:15:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:52884 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbaKXUP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:15:28 -0500
Date: Mon, 24 Nov 2014 15:15:24 -0500 (EST)
Message-Id: <20141124.151524.133147922038005100.davem@davemloft.net>
To: pagupta@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jasowang@redhat.com,
        dgibson@redhat.com, vfalico@gmail.com, edumazet@google.com,
        vyasevic@redhat.com, hkchu@google.com, xemul@parallels.com,
        therbert@google.com, bhutchings@solarflare.com, xii@google.com,
        stephen@networkplumber.org, jiri@resnulli.us,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v2 net-net 0/4] Increase the limit of tuntap queues
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416854006-10041-1-git-send-email-pagupta@redhat.com>
References: <1416854006-10041-1-git-send-email-pagupta@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Nov 2014 12:15:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Your header message says "0/4" as if there will be 4 patches, but then
you posted a 3 patch series.

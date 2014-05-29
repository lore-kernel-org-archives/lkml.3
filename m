Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaE2WgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:36:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47165 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaE2WgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:36:23 -0400
Date: Thu, 29 May 2014 15:36:22 -0700 (PDT)
Message-Id: <20140529.153622.764478286337271648.davem@davemloft.net>
To: linus.luessing@web.de
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCHv2 net-next 0/4] bridge: multicast snooping patches /
 exports
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400994205-31165-1-git-send-email-linus.luessing@web.de>
References: <1400994205-31165-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 May 2014 15:36:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Sun, 25 May 2014 07:03:21 +0200

> Changes in v2:

I really need a bridging expert to review this series, thank you.

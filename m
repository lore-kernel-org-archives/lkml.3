Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200Ab3HNCKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 22:10:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46354 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759029Ab3HNCKN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 22:10:13 -0400
Date: Tue, 13 Aug 2013 19:10:07 -0700 (PDT)
Message-Id: <20130813.191007.1554363427677331939.davem@davemloft.net>
To: ast@fiberby.net
Cc: vyasevic@redhat.com, stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Bridge VLAN kernel/iproute2 incompatibility
From: David Miller <davem@davemloft.net>
In-Reply-To: <52090C26.4090001@fiberby.net>
References: <52090C26.4090001@fiberby.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 13 Aug 2013 19:10:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Date: Mon, 12 Aug 2013 16:24:06 +0000

> Let's start with a little history:

I've applied your kernel patch, but the detailed analysis you put
here, belongs in the commit message.

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbaAIU6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:58:40 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33861 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaAIU6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:58:30 -0500
Date: Thu, 09 Jan 2014 15:58:27 -0500 (EST)
Message-Id: <20140109.155827.536194406324178452.davem@davemloft.net>
To: jim.epost@gmail.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org
Subject: Re: randconfig build error with next-20140109, in
 net/ipv6/ip6_vti.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+r1Zhg2srn3FkJcjKg0xiwbR89127sockdNQiGqUYn1qYTC0g@mail.gmail.com>
References: <CA+r1Zhg2srn3FkJcjKg0xiwbR89127sockdNQiGqUYn1qYTC0g@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 09 Jan 2014 12:58:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Davis <jim.epost@gmail.com>
Date: Thu, 9 Jan 2014 06:55:50 -0700

> Building with the attached random configuration file,

I cannot reproduce this in either the 'net' or 'net-next' tree.

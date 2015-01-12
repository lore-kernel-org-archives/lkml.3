Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbbALCu7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 21:50:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43147 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbbALCu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 21:50:56 -0500
Date: Sun, 11 Jan 2015 21:50:50 -0500 (EST)
Message-Id: <20150111.215050.458358747958425038.davem@davemloft.net>
To: richard@nod.at
Cc: joe@perches.com, coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bhutchings@solarflare.com, john.fastabend@gmail.com,
        herbert@gondor.apana.org.au, vyasevic@redhat.com, jiri@resnulli.us,
        vfalico@gmail.com, therbert@google.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, jmorris@namei.org, kuznet@ms2.inr.ac.ru,
        kadlec@blackhole.kfki.hu, kaber@trash.net, pablo@netfilter.org,
        kay@vrfy.org, stephen@networkplumber.org
Subject: Re: [PATCH 3/3] x_tables: Factor out 16bit aligment
 ifname_compare()
From: David Miller <davem@davemloft.net>
In-Reply-To: <54B2EE4D.2080802@nod.at>
References: <54B2EB81.5050604@nod.at>
	<1421012376.9233.9.camel@perches.com>
	<54B2EE4D.2080802@nod.at>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Jan 2015 18:50:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>
Date: Sun, 11 Jan 2015 22:42:37 +0100

> Joe, I really don't care. This is the least significant
> patch of the series.
> I'll no longer waste my time with that.

If you're not willing to fix stylistic issues now, then nobody should
bother wasting their time on the high level issues of your patch.

Just fix these things now rather than being difficult, this is a part
of patch review that everyone has to do, not just you.

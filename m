Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab3ITP70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 11:59:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37393 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3ITP7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 11:59:24 -0400
Date: Fri, 20 Sep 2013 11:59:22 -0400 (EDT)
Message-Id: <20130920.115922.1753824753898372116.davem@davemloft.net>
To: joe@perches.com
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, mpatocka@redhat.com,
        gregkh@linuxfoundation.org, rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stable_kernel_rules.txt: Exclude networking from
 stable rules
From: David Miller <davem@davemloft.net>
In-Reply-To: <1379688880.2021.38.camel@joe-AO722>
References: <alpine.LRH.2.02.1309191359300.12162@file01.intranet.prod.int.rdu2.redhat.com>
	<1379615474.22168.13.camel@joe-AO722>
	<1379688880.2021.38.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 20 Sep 2013 08:59:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 20 Sep 2013 07:54:40 -0700

> On Thu, 2013-09-19 at 11:31 -0700, Joe Perches wrote:
>> Networking is once again "special", so at least document
>> how it's working today in the hope that doing so makes
>> less work for all that actually read the documentation.
> 
> David, why did you mark this N/A is patchwork?
> It's your rule, why not document it?

Because it should go through whoever maintains that document, and
that isn't me.

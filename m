Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaBLWsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 17:48:09 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:32887 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaBLWsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 17:48:08 -0500
Date: Wed, 12 Feb 2014 17:48:06 -0500 (EST)
Message-Id: <20140212.174806.1566294294678988694.davem@davemloft.net>
To: tytso@mit.edu
Cc: postmaster@vger.kernel.org, kees@outflux.net, davej@redhat.com,
        pablo@netfilter.org, kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: flaw in "nf_tables: add reject module for NFPROTO_INET"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140212224058.GA7237@thunk.org>
References: <20140212213151.GB12617@thunk.org>
	<20140212214112.GN23300@outflux.net>
	<20140212224058.GA7237@thunk.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Feb 2014 14:48:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>
Date: Wed, 12 Feb 2014 17:40:58 -0500

> Would it be possible to set up a new mailing list on vger.kernel.org,
> linux-coverity@vger.kernel.org?

Done.

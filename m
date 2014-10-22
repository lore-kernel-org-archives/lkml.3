Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbaJVBoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 21:44:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54115 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbaJVBoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 21:44:23 -0400
Date: Tue, 21 Oct 2014 21:44:22 -0400 (EDT)
Message-Id: <20141021.214422.448340967510694149.davem@davemloft.net>
To: ast@plumgrid.com
Cc: hannes@stressinduktion.org, dborkman@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] bpf: fix bug in eBPF verifier
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413842097-4380-1-git-send-email-ast@plumgrid.com>
References: <1413842097-4380-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Oct 2014 18:44:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Mon, 20 Oct 2014 14:54:57 -0700

> while comparing for verifier state equivalency the comparison
> was missing a check for uninitialized register.
> Make sure it does so and add a testcase.
> 
> Fixes: f1bca824dabb ("bpf: add search pruning optimization to verifier")
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>

Applied, thanks.

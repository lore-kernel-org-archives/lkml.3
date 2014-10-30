Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076AbaJ3TpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:45:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58550 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761055AbaJ3TpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:45:18 -0400
Date: Thu, 30 Oct 2014 15:45:15 -0400 (EDT)
Message-Id: <20141030.154515.250654452794791308.davem@davemloft.net>
To: ast@plumgrid.com
Cc: hannes@stressinduktion.org, edumazet@google.com, dborkman@redhat.com,
        luto@amacapital.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] reduce verifier memory consumption and
 add tests
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414534303-9906-1-git-send-email-ast@plumgrid.com>
References: <1414534303-9906-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Oct 2014 12:45:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Tue, 28 Oct 2014 15:11:40 -0700

> Small set of cleanups:
>  - reduce verifier memory consumption
>  - add verifier test to check register state propagation and state equivalence
>  - add JIT test reduced from recent nmap triggered crash

Series applied, thanks.

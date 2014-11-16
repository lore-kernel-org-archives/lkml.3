Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbaKPVeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 16:34:20 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38648 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaKPVeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 16:34:19 -0500
Date: Sun, 16 Nov 2014 16:34:15 -0500 (EST)
Message-Id: <20141116.163415.1667397687779909689.davem@davemloft.net>
To: ast@plumgrid.com
Cc: mingo@kernel.org, luto@amacapital.net, dborkman@redhat.com,
        hannes@stressinduktion.org, edumazet@google.com,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 6/7] bpf: allow eBPF programs to use maps
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMEtUuwrST6wGnBU6UU2NYEubskHYf1XZmZQpkgM+cUc8YD9OA@mail.gmail.com>
References: <1415929010-9361-7-git-send-email-ast@plumgrid.com>
	<20141116.140422.570375628237589645.davem@davemloft.net>
	<CAMEtUuwrST6wGnBU6UU2NYEubskHYf1XZmZQpkgM+cUc8YD9OA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Nov 2014 13:34:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Sun, 16 Nov 2014 13:24:53 -0800

> The requirement that _unprivileged_ programs should
> not be able to pass all these pointers back to user is
> well understood and was discussed in detail several
> month back. It's verifier that will prevent leaking of
> kernel addresses.

Ok, fair enough.

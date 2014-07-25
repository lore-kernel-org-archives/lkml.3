Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbaGYG1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:27:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58748 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaGYG1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:27:33 -0400
Date: Thu, 24 Jul 2014 23:27:31 -0700 (PDT)
Message-Id: <20140724.232731.311277115312586882.davem@davemloft.net>
To: ast@plumgrid.com
Cc: dborkman@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next] net: filter: rename 'struct
 sock_filter_int' into 'struct bpf_insn'
From: David Miller <davem@davemloft.net>
In-Reply-To: <1406245101-21262-1-git-send-email-ast@plumgrid.com>
References: <1406245101-21262-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Jul 2014 23:27:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Thu, 24 Jul 2014 16:38:21 -0700

> eBPF is used by socket filtering, seccomp and soon by tracing and
> exposed to userspace, therefore 'sock_filter_int' name is not accurate.
> Rename it to 'bpf_insn'
> 
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
> ---
> v1->v2: fix alignment of \ in macros (caught by Daniel. thanks!)

Applied, thanks.

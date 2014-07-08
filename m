Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbaGHVLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:11:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54251 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbaGHVLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:11:38 -0400
Date: Tue, 08 Jul 2014 14:11:37 -0700 (PDT)
Message-Id: <20140708.141137.1850005112297468089.davem@davemloft.net>
To: zlim.lnx@gmail.com
Cc: dborkman@redhat.com, ast@plumgrid.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 net-next] net: filter: move load_pointer() into
 filter.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404399414-32099-1-git-send-email-zlim.lnx@gmail.com>
References: <1404399414-32099-1-git-send-email-zlim.lnx@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 14:11:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zi Shen Lim <zlim.lnx@gmail.com>
Date: Thu,  3 Jul 2014 07:56:54 -0700

> load_pointer() is already a static inline function.
> Let's move it into filter.h so BPF JIT implementations can reuse this
> function.
> 
> Since we're exporting this function, let's also rename it to
> bpf_load_pointer() for clarity.
> 
> Signed-off-by: Zi Shen Lim <zlim.lnx@gmail.com>
> ---
> v1->v2:
> * Renamed to more specific name of bpf_load_pointer(), as suggested
>   by Daniel.

Applied, thank you.

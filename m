Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935061Ab3E2G7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 02:59:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32896 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933908Ab3E2G7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 02:59:31 -0400
Date: Tue, 28 May 2013 23:59:30 -0700 (PDT)
Message-Id: <20130528.235930.817011402865677291.davem@davemloft.net>
To: sergei.shtylyov@cogentembedded.com
Cc: federico.vaga@gmail.com, nhorman@tuxdriver.com, edumazet@google.com,
        lizefan@huawei.com, akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/core/sock.c: add missing VSOCK string in
 af_family_*_key_strings
From: David Miller <davem@davemloft.net>
In-Reply-To: <51A4F05C.90001@cogentembedded.com>
References: <1369753364-10043-1-git-send-email-federico.vaga@gmail.com>
	<51A4F05C.90001@cogentembedded.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Tue, 28 May 2013 21:58:52 +0400

> Hello.
> 
> On 28-05-2013 19:02, Federico Vaga wrote:
> 
>> The three arrays of strings: af_family_kay_strings,
> 
>    s/kay/key/. Maybe whoever applies this could fix the typo...

Applied with typo fixed and queued up for -stable.

Thanks.

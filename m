Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3JBUhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:37:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49064 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3JBUhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:37:53 -0400
Date: Wed, 02 Oct 2013 16:37:51 -0400 (EDT)
Message-Id: <20131002.163751.1094931323876276388.davem@davemloft.net>
To: baker.kernel@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 net-next] fib_trie: avoid a redundant bit judgement
 in inflate
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380584709-5877-1-git-send-email-baker.kernel@gmail.com>
References: <1380584709-5877-1-git-send-email-baker.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 02 Oct 2013 13:37:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: baker.kernel@gmail.com
Date: Tue,  1 Oct 2013 07:45:09 +0800

> From: "baker.zhang" <baker.kernel@gmail.com>
> 
> Because 'node' is the i'st child of 'oldnode',
> thus, here 'i' equals
> tkey_extract_bits(node->key, oldtnode->pos, oldtnode->bits)
> 
> we just get 1 more bit,
> and need not care the detail value of this bits.
> 
> I apologize for the mistake.
> 
> I generated the patch on a branch version,
> and did not notice the put_child has been changed.
> 
> I have redone the test on HEAD version with my patch.

Applied, thanks for testing things so thoroughly.

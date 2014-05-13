Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997AbaEMEEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 00:04:25 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:40019 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaEMEEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 00:04:24 -0400
Message-ID: <1399953861.7973.42.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] e1000: To filter the negative skb->len
From: Eric Dumazet <eric.dumazet@gmail.com>
To: xuyongjiande@gmail.com
Cc: linux.nics@intel.com, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 12 May 2014 21:04:21 -0700
In-Reply-To: <1399951987-10434-1-git-send-email-xuyongjiande@gmail.com>
References: <1399951987-10434-1-git-send-email-xuyongjiande@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-13 at 11:33 +0800, xuyongjiande@gmail.com wrote:
> From: Yongjian Xu <xuyongjiande@gmail.com>
> 
> skb->len is unsigned int, "skb->len <= 0" should be "(int)(skb->len) <= 0".

Why ?

Did you hit a case skb->len would be 0 or 'negative' ?

This test makes no sense, just remove it.




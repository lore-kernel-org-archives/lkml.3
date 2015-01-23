Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbbAWJFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:05:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46262 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbbAWJFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:05:13 -0500
Date: Fri, 23 Jan 2015 01:05:12 -0800 (PST)
Message-Id: <20150123.010512.1146105257829562941.davem@davemloft.net>
To: md.jamalmohiuddin@gmail.com
Cc: therbert@google.com, edumazet@google.com, viro@zeniv.linux.org.uk,
        alexander.h.duyck@redhat.com, willemb@google.com,
        hannes@stressinduktion.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include:linux:Optimizations to __skb_push
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421949760-5705-1-git-send-email-md.jamalmohiuddin@gmail.com>
References: <1421949760-5705-1-git-send-email-md.jamalmohiuddin@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Jan 2015 01:05:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Date: Thu, 22 Jan 2015 23:32:40 +0530

> This patch optimizes __skb_push function
> 
> Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>

A patch with a commit message that doesn't even explain the
optimization, or why it is worthwhile to make that optimization,
will not be applied, sorry.

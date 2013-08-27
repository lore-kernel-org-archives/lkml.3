Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3H0UEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:04:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59429 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3H0UEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:04:20 -0400
Date: Tue, 27 Aug 2013 16:04:18 -0400 (EDT)
Message-Id: <20130827.160418.496317549649654714.davem@davemloft.net>
To: cl@linux.com
Cc: tj@kernel.org, akpm@linuxfoundation.org, linux-arch@vger.kernel.org,
        srostedt@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [guv 12/16] sparc: __get_cpu_var conversion
From: David Miller <davem@davemloft.net>
In-Reply-To: <00000140ac8e2da8-5377b093-cdf2-434d-bf64-4fdca4f741b0-000000@email.amazonses.com>
References: <20130823190135.726207430@linux.com>
	<00000140ac8e2da8-5377b093-cdf2-434d-bf64-4fdca4f741b0-000000@email.amazonses.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 27 Aug 2013 13:04:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>
Date: Fri, 23 Aug 2013 19:02:13 +0000

> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: David S. Miller <davem@davemloft.net>

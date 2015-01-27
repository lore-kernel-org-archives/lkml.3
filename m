Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbbA0BVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:21:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46558 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbbA0BVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:21:06 -0500
Date: Mon, 26 Jan 2015 17:21:05 -0800 (PST)
Message-Id: <20150126.172105.1534389490254826705.davem@davemloft.net>
To: ast@plumgrid.com
Cc: holzheu@linux.vnet.ibm.com, schwidefsky@de.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] bpf: fix two bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421975469-13035-1-git-send-email-ast@plumgrid.com>
References: <1421975469-13035-1-git-send-email-ast@plumgrid.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 26 Jan 2015 17:21:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Thu, 22 Jan 2015 17:11:07 -0800

> Michael Holzheu caught two issues (in bpf syscall and in the test).
> Fix them. Details in corresponding patches.

Series applied, thanks.

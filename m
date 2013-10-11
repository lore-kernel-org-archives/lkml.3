Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3JKSzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 14:55:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab3JKSzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 14:55:44 -0400
Date: Fri, 11 Oct 2013 11:55:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Weijie Yang <weijie.yang.kh@gmail.com>, Bob Liu <bob.liu@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shaohua Li <shli@fusionio.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] swap: fix set_blocksize race during swapon/swapoff
Message-Id: <20131011115542.a81a9215d9b876706ec58a72@linux-foundation.org>
In-Reply-To: <1381485262-16792-1-git-send-email-k.kozlowski@samsung.com>
References: <1381485262-16792-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct 2013 11:54:22 +0200 Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:

> Swapoff used old_block_size from swap_info which could be overwritten by
> concurrent swapon.

Better changelogs, please.  What were the user-visible effects of the
bug, and how is it triggered?

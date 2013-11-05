Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3KEVKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 16:10:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab3KEVK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 16:10:28 -0500
Date: Tue, 5 Nov 2013 13:10:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: <micky_ching@realsil.com.cn>
Cc: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <sameo@linux.intel.com>, <maximlevitsky@gmail.com>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <oakad@yahoo.com>, <wei_wang@realsil.com.cn>
Subject: Re: [PATCH] memstick: rtsx: fix ms card data transfer bug
Message-Id: <20131105131027.4ce3bc298266bd82104f5fce@linux-foundation.org>
In-Reply-To: <1383115216-11967-1-git-send-email-micky_ching@realsil.com.cn>
References: <1383115216-11967-1-git-send-email-micky_ching@realsil.com.cn>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013 14:40:16 +0800 <micky_ching@realsil.com.cn> wrote:

> unlike mspro card, ms card use normal read/write mode for DMA
> data transfer.

What are the user-visible effects of this bug?

Please always include this information when fixing bugs so that others
can decide whether they (or their customers) need the patch.


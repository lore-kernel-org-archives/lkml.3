Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaHNUe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 16:34:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbaHNUe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 16:34:27 -0400
Date: Thu, 14 Aug 2014 13:34:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kpark3469@gmail.com
Cc: keun-o.park@windriver.com, hpa@zytor.com, rafael.j.wysocki@intel.com,
        peterz@infradead.org, rusty@rustcorp.com.au,
        kirill.shutemov@linux.intel.com, oleg@redhat.com, prarit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] earlyprintk: re-enable earlyprintk calling early_param
Message-Id: <20140814133425.0677d072ff45bce8431baae1@linux-foundation.org>
In-Reply-To: <1408011216-8621-1-git-send-email-kpark3469@gmail.com>
References: <1408011216-8621-1-git-send-email-kpark3469@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2014 19:13:36 +0900 kpark3469@gmail.com wrote:

> From: Sahara <keun-o.park@windriver.com>
> 
> Although there are many obs_kernel_param and its names are
> earlyprintk and also EARLY_PRINTK is also enabled, we could not
> see the early_printk output properly until now. This patch
> considers earlycon as well as earlyprintk.

Sorry, I just don't understand this description.

What does the patch actually do?  What was the kernel behaviour without
the patch and what is the kernel behaviour with the patch?


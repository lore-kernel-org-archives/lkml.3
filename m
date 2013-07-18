Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934516Ab3GRVjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 17:39:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250Ab3GRVja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 17:39:30 -0400
Date: Thu, 18 Jul 2013 14:39:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jerry <uulinux@gmail.com>
Cc: zhuwei.lu@archermind.com, tianfu.huang@archermind.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: negative left shift count when PAGE_SHIFT > 20
Message-Id: <20130718143928.4f9b45807956e2fdb1ee3a22@linux-foundation.org>
In-Reply-To: <1374166572-7988-1-git-send-email-uulinux@gmail.com>
References: <1374166572-7988-1-git-send-email-uulinux@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jul 2013 00:56:12 +0800 Jerry <uulinux@gmail.com> wrote:

> When PAGE_SHIFT > 20, the result of "20 - PAGE_SHIFT" is negative. The
> calculating here will generate an unexpected result. In addition, if
> PAGE_SHIFT > 20, The memory size represented by numentries was already
> integral multiple of 1MB.
> 

If you tell me that you have a machine which has PAGE_SIZE=2MB and this
was the only problem which prevented Linux from running on that machine
then I'll apply the patch ;)


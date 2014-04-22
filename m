Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbaDVTzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:55:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684AbaDVTzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:55:41 -0400
Date: Tue, 22 Apr 2014 12:55:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: "'Minchan Kim'" <minchan@kernel.org>, "'Nitin Gupta'" <ngupta@vflare.org>,
        iamjoonsoo.kim@lge.com,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Bob Liu'" <bob.liu@oracle.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] zram: correct offset usage in zram_bio_discard
Message-Id: <20140422125539.f40a414ca0dbae703a23b977@linux-foundation.org>
In-Reply-To: <000001cf5dd8$ecf1c360$c6d54a20$%yang@samsung.com>
References: <000001cf5dd8$ecf1c360$c6d54a20$%yang@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 11:14:02 +0800 Weijie Yang <weijie.yang@samsung.com> wrote:

> we want to skip the logical block which is partially covered by
> the discard bio, so check the remaining size and subtract it if
> there is a need to goto the next logical block.
> 
> This patch corrects the offset usage in zram_bio_discard.
> 

What were the end-user visible effects of the bug?

Please always include this information when fixing something so that
others can work out which kernel(s) need patching.


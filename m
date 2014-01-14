Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbaANAgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:36:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbaANAgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:36:22 -0500
Date: Mon, 13 Jan 2014 16:36:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, qiuxishi@huawei.com,
        dhowells@redhat.com, daeseok.youn@gmail.com, liuj97@gmail.com,
        yinghai@kernel.org, zhangyanfei@cn.fujitsu.com,
        santosh.shilimkar@ti.com, grygorii.strashko@ti.com,
        tangchen@cn.fujitsu.com
Subject: Re: [PATCH V3 2/2] mm/memblock: Add support for excluded memory
 areas
Message-Id: <20140113163620.ade5ee9171c5f443a227f8af@linux-foundation.org>
In-Reply-To: <1389618217-48166-3-git-send-email-phacht@linux.vnet.ibm.com>
References: <1389618217-48166-1-git-send-email-phacht@linux.vnet.ibm.com>
	<1389618217-48166-3-git-send-email-phacht@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jan 2014 14:03:37 +0100 Philipp Hachtmann <phacht@linux.vnet.ibm.com> wrote:

> Add a new memory state "nomap" to memblock. This can be used to truncate
> the usable memory in the system without forgetting about what is really
> installed.
> 
> ...
>
>  5 files changed, 254 insertions(+), 70 deletions(-)

Patch is big.  I'll toss this in for some testing but it does look too
large and late for 3.14.  How will this affect your s390 development?

Hopefully some people who are familiar with memblock will have time to
review this carefully, please.


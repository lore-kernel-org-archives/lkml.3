Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaANWBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:01:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaANWBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:01:19 -0500
Date: Tue, 14 Jan 2014 14:01:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, qiuxishi@huawei.com,
        dhowells@redhat.com, daeseok.youn@gmail.com, liuj97@gmail.com,
        yinghai@kernel.org, zhangyanfei@cn.fujitsu.com,
        santosh.shilimkar@ti.com, grygorii.strashko@ti.com,
        tangchen@cn.fujitsu.com
Subject: Re: [PATCH V3 2/2] mm/memblock: Add support for excluded memory
 areas
Message-Id: <20140114140117.bff3db92027fea9eb6f2af7f@linux-foundation.org>
In-Reply-To: <20140114104253.54ea0470@lilie>
References: <1389618217-48166-1-git-send-email-phacht@linux.vnet.ibm.com>
	<1389618217-48166-3-git-send-email-phacht@linux.vnet.ibm.com>
	<20140113163620.ade5ee9171c5f443a227f8af@linux-foundation.org>
	<20140114104253.54ea0470@lilie>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014 10:42:53 +0100 Philipp Hachtmann <phacht@linux.vnet.ibm.com> wrote:

> Am Mon, 13 Jan 2014 16:36:20 -0800
> schrieb Andrew Morton <akpm@linux-foundation.org>:
> 
> > Patch is big.  I'll toss this in for some testing but it does look too
> > large and late for 3.14.  How will this affect your s390 development?
> 
> It is needed for s390 bootmem -> memblock transition. The s390 dump
> mechanisms cannot be switched to memblock (from using something s390
> specific called memory_chunk) without the nomap list.
> I'm also working on another enhancement on s390 that will rely on a
> clean transition to memblock.
> 
> I have written and tested the stuff on top of our local development
> tree. And then realised that it does not fit the linux-next tree. So I
> converted it to fit linux-next and posted it. Have to maintain two
> versions now. 

So at 3.14-rc1 everything will come good - get the review issues sorted
out, add the patch to your tree (and hence linux-next).

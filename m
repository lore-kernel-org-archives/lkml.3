Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab3KEU1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:27:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab3KEU1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:27:05 -0500
Date: Tue, 5 Nov 2013 15:26:31 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jingbai Ma <jingbai.ma@hp.com>
Cc: ptesarik@suse.cz, d.hatayama@jp.fujitsu.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, bhe@redhat.com, tom.vaden@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        lisa.mitchell@hp.com, anderson@redhat.com, ebiederm@xmission.com
Subject: Re: [PATCH 0/3] makedumpfile: hugepage filtering for vmcore dump
Message-ID: <20131105202631.GC4598@redhat.com>
References: <20131105134532.32112.78008.stgit@k.asiapacific.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105134532.32112.78008.stgit@k.asiapacific.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 09:45:32PM +0800, Jingbai Ma wrote:
> This patch set intend to exclude unnecessary hugepages from vmcore dump file.
> 
> This patch requires the kernel patch to export necessary data structures into
> vmcore: "kexec: export hugepage data structure into vmcoreinfo"
> http://lists.infradead.org/pipermail/kexec/2013-November/009997.html
> 
> This patch introduce two new dump levels 32 and 64 to exclude all unused and
> active hugepages. The level to exclude all unnecessary pages will be 127 now.

Interesting. Why hugepages should be treated any differentely than normal
pages?

If user asked to filter out free page, then it should be filtered and
it should not matter whether it is a huge page or not?

Thanks
Vivek

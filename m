Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaC2NaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 09:30:25 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:44693 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaC2NaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 09:30:23 -0400
Date: Sat, 29 Mar 2014 09:30:18 -0400
From: Tejun Heo <tj@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/percpu.c: renew the max_contig if we merge the
 head and previous block
Message-ID: <20140329133018.GD5553@htj.dyndns.org>
References: <1396011321-19759-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396011321-19759-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 08:55:21PM +0800, Jianyu Zhan wrote:
> Hi, tj,
> I've reworked the patches on top of percpu/for-3.15.
> 
> During pcpu_alloc_area(), we might merge the current head with the
> previous block. Since we have calculated the max_contig using the
> size of previous block before we skip it, and now we update the size
> of previous block, so we should renew the max_contig.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Applied to percpu/for-3.15.

Thanks!

-- 
tejun

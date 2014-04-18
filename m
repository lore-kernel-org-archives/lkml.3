Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaDRRM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:12:28 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:50106 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaDRRMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:12:25 -0400
Date: Fri, 18 Apr 2014 13:12:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 4/8] idr: fix idr_replace()'s returned error code
Message-ID: <20140418171222.GC23576@htj.dyndns.org>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
 <1397825404-12039-5-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397825404-12039-5-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 08:49:51PM +0800, Lai Jiangshan wrote:
> When the smaller id is not found, idr_replace() returns -ENOENT.
> But when the id is bigger enough, idr_replace() returns -EINVAL,
> actually there is no difference between these two kinds of ids.
> 
> These are all unallocated id, the return values of the idr_replace()
> for these ids should be the same: -ENOENT.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

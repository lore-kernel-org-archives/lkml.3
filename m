Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaLBSEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:04:24 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:62306 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbaLBSEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:04:09 -0500
Date: Tue, 2 Dec 2014 13:04:06 -0500
From: Tejun Heo <tj@kernel.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/9] percpu: Replace smp_read_barrier_depends() with
 lockless_dereference()
Message-ID: <20141202180406.GH10918@htj.dyndns.org>
References: <1416582363-20661-1-git-send-email-bobby.prani@gmail.com>
 <1416582363-20661-6-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416582363-20661-6-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 10:05:59AM -0500, Pranith Kumar wrote:
> Recently lockless_dereference() was added which can be used in place of
> hard-coding smp_read_barrier_depends(). The following PATCH makes the change.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Applied to percpu/for-3.19.

Thanks.

-- 
tejun

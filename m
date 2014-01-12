Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148AbaALDjJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 22:39:09 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:37349 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaALDjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 22:39:07 -0500
Date: Sat, 11 Jan 2014 22:39:02 -0500
From: Tejun Heo <tj@kernel.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHv3 03/11] percpu: use VMALLOC_TOTAL instead of
 VMALLOC_END - VMALLOC_START
Message-ID: <20140112033902.GC7874@mtj.dyndns.org>
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
 <1388699609-18214-4-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388699609-18214-4-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 01:53:21PM -0800, Laura Abbott wrote:
> vmalloc already gives a useful macro to calculate the total vmalloc
> size. Use it.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Applied to percpu/for-3.14.  Thanks.

-- 
tejun

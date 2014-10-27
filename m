Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaJ0OIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:08:32 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:50201 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaJ0OIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:08:30 -0400
Date: Mon, 27 Oct 2014 10:08:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Zhihui Zhang <zzhsuny@gmail.com>
Cc: cl@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [percpu] Make the unit size of the first chunk the same
 as other chunks
Message-ID: <20141027140826.GJ4436@htj.dyndns.org>
References: <1414249558-6677-1-git-send-email-zzhsuny@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414249558-6677-1-git-send-email-zzhsuny@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 11:05:58AM -0400, Zhihui Zhang wrote:
> Since we have already allocated the full unit size for the first chunk, we might as well use
> it so that the unit size are the same for all chunks. The page first chunk allocator already
> has this effect because it allocates one page at a time.

I'm not following.  Where do we allocate the full unit size for the
first chunk?

Thanks.

-- 
tejun

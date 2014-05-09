Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbaEITMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:12:49 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:54791 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303AbaEITMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:12:41 -0400
Date: Fri, 9 May 2014 15:12:38 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH percpu/for-3.16 2/2] percpu-refcount: implement
 percpu_ref_tryget()
Message-ID: <20140509191238.GB4486@htj.dyndns.org>
References: <20140507155511.GB26540@htj.dyndns.org>
 <20140507155647.GC26540@htj.dyndns.org>
 <20140507155810.GD26540@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507155810.GD26540@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 11:58:10AM -0400, Tejun Heo wrote:
> Implement percpu_ref_tryget() which fails if the refcnt already
> reached zero.  Note that this is different from the recently renamed
> percpu_ref_tryget_live() which fails if the refcnt has been killed and
> is draining the remaining references.  percpu_ref_tryget() succeeds on
> a killed refcnt as long as its current refcnt is above zero.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Kent Overstreet <kmo@daterainc.com>

Applying 1-2 to percpu/for-3.16.

Thanks.

-- 
tejun

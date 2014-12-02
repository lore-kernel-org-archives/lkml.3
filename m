Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbaLBQk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:40:29 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:52738 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbaLBQk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:40:27 -0500
Date: Tue, 2 Dec 2014 11:40:24 -0500
From: Tejun Heo <htejun@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Final per cpu consistency patch for -next or late in 3.19 merge
 period
Message-ID: <20141202164024.GA10918@htj.dyndns.org>
References: <alpine.DEB.2.11.1411281229350.11435@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411281229350.11435@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Fri, Nov 28, 2014 at 12:31:22PM -0600, Christoph Lameter wrote:
> This is the final patch to remove __get_cpu_var. I checked -next and there
> are no remaining uses of __get_cpu_var. So either merge this to -next or
> wait until 3.19 late.
> 
> However, if we wait till 3.19 then I may have to do another pass if
> people add more uses of __get_cpu_var and submit another patch.
> 
> From: Christoph Lameter <cl@linux.com>
> Date: Tue, 29 Jul 2014 16:09:54 -0500
> Subject: [PATCH] Remove __get_cpu_var and __raw_get_cpu_var macros
> 
> No user is left in the kernel source tree. Therefore we can
> drop the definitions.
> 
> This is the final merge of the transition away from __get_cpu_var.
> After this patch the kernel will not build if anyone uses __get_cpu_var.

Can you please update Documentation/local_ops.txt and comments which
contain __get_cpu_var() and send the updated patch to Andrew?

Andrew, this is removal of the two deprecated per-cpu accessors.  All
the existing users are gone from the devel branches and thus from -mm.
Can you please route this once Christoph posts an updated version?

Thanks.

-- 
tejun

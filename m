Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbaEERhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:37:09 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:54164 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaEERhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:37:05 -0400
Date: Mon, 5 May 2014 13:37:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] kernel/cgroup.c: replace pr_warning by pr_warn
Message-ID: <20140505173701.GN11231@htj.dyndns.org>
References: <20140505193517.e8f4be9e4f9866ffcfa3de28@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505193517.e8f4be9e4f9866ffcfa3de28@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 07:35:17PM +0200, Fabian Frederick wrote:
> This patch also fixes 2 kernel-doc warnings.

cgroup/for-3.16 already has a patch to convert to pr_warn().  Can you
please separate out the kdoc fixes?

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab3J1QfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:35:17 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:40209 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3J1QfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:35:13 -0400
Date: Mon, 28 Oct 2013 12:35:09 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: Re: Subject: [PATCHSET driver-core-next] sysfs: separate out kernfs,
 part #1
Message-ID: <20131028163509.GG13548@mtj.dyndns.org>
References: <1382629780-10006-1-git-send-email-tj@kernel.org>
 <20131028130654.GD13548@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028130654.GD13548@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 09:06:54AM -0400, Tejun Heo wrote:
> Hello, guys.
> 
> Just posted updated patches incorporating Pavel's suggestions.  Only
> the patches which need to be updated are reposted.  The whole series
> can be found in the following branch.  It's based on top of today's
> driver-core-next 6fffcfa7c0fc ("devres: restore zeroing behavior of
> devres_alloc()").
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-separate-out-kernfs

Updated again to reflect bug report from Fengguang.  The git tree has
been updated accordingly.  Please give me a holler if someone wants
the whole series to be reposted.

Thanks.

-- 
tejun

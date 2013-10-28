Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3J1NG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:06:59 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:64559 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab3J1NG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:06:58 -0400
Date: Mon, 28 Oct 2013 09:06:54 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: Re: Subject: [PATCHSET driver-core-next] sysfs: separate out kernfs,
 part #1
Message-ID: <20131028130654.GD13548@mtj.dyndns.org>
References: <1382629780-10006-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382629780-10006-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

Just posted updated patches incorporating Pavel's suggestions.  Only
the patches which need to be updated are reposted.  The whole series
can be found in the following branch.  It's based on top of today's
driver-core-next 6fffcfa7c0fc ("devres: restore zeroing behavior of
devres_alloc()").

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-separate-out-kernfs

Thanks.

-- 
tejun

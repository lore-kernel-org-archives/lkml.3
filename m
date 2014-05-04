Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaEDT0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 15:26:36 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:56324 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaEDT0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 15:26:34 -0400
Date: Sun, 4 May 2014 15:26:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: axboe@kernel.dk, Li Zefan <lizefan@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        cgroups@vger.kernel.org
Subject: Re: blkcg: circular dependency between blkcg_pol_mutex and s_active
Message-ID: <20140504192630.GE26279@htj.dyndns.org>
References: <5363C04B.4010400@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5363C04B.4010400@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 02, 2014 at 11:56:59AM -0400, Sasha Levin wrote:
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel I've stumbled on the following:

This is a highly unlikely deadlock which got introduced by recent
changes in cgroup core.  I'm working to further simplify locking in
cgroup core.  Will prep a quick fix for this issue soon.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab3IXMEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 08:04:37 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:47362 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3IXMEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 08:04:36 -0400
Date: Tue, 24 Sep 2013 08:04:29 -0400
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info' in
 all related extern functions
Message-ID: <20130924120429.GA2366@htj.dyndns.org>
References: <5212DBFA.8030805@asianux.com>
 <20130923150625.GB14547@htj.dyndns.org>
 <52410A40.1000304@asianux.com>
 <20130924040601.GA31575@mtj.dyndns.org>
 <524114B8.3070903@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524114B8.3070903@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 12:27:36PM +0800, Chen Gang wrote:
> For real world, /sbin/init will call setgroups, so user space 'help'
> kernel itself to protect this issue, but I think, we don't only depend
> on the user space help checking.
> 
> The proof is below:
> 
>   [root@gchenlinux tmp]# grep setgroups /sbin/*
>   Binary file /sbin/init matches
>   Binary file /sbin/rpc.statd matches
>   Binary file /sbin/rsyslogd matches
>   Binary file /sbin/runuser matches
> 
> From reading kernel source code, kernel itself does not intend to set
> 'group_info', it is triggered by user space or another kernel mode
> sub-systems.

Can you please demonstrate such failure?  You can tell kernel to
execute a given binary instead of init with "init=" param.

Thanks.

-- 
tejun

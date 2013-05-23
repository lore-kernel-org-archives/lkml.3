Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab3EWSRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 14:17:36 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46334 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab3EWSRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 14:17:35 -0400
Date: Thu, 23 May 2013 10:28:49 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: jason.wessel@windriver.com, sasha.levin@oracle.com,
        vincent.stehle@laposte.net, john.blackwood@ccur.com,
        kgdb-bugreport@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/debug/kdb: code enhancement for 3 areas.
Message-ID: <20130523172849.GB30160@teo>
References: <5194C23A.3090405@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5194C23A.3090405@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 07:25:46PM +0800, Chen Gang wrote:
> Delete waste '{' for 'case' statement.
> 
> For the return variable 'long res' in function kdb_task_state_string(),
> neither it matches the function return type 'unsigned long', nor is
> suitable as a flag variable to make 'or' operation. So use 'unsigned
> long' instead of 'long'.
> 
> If "case 'A'" happen in function kdb_task_state_string(), can return
> ~0UL directly to save the useless looping.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

If anything, these should be 3 separate patches...

Thanks!

Anton

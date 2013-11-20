Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab3KTIFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:05:25 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:65084 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3KTIFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:05:21 -0500
Date: Wed, 20 Nov 2013 00:05:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: linux-kernel@vger.kernel.org
cc: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com,
        hannes@cmpxchg.org
Subject: Re: [to-be-updated] mm-memcg-add-memoryoom_control-notification-for-system-oom.patch
 removed from -mm tree
In-Reply-To: <528bda46.YlEwHwHdykzBNvfr%akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1311200002570.20752@chino.kir.corp.google.com>
References: <528bda46.YlEwHwHdykzBNvfr%akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013, akpm@linux-foundation.org wrote:

> Subject: [to-be-updated] mm-memcg-add-memoryoom_control-notification-for-system-oom.patch removed from -mm tree
> To: rientjes@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
> From: akpm@linux-foundation.org
> Date: Tue, 19 Nov 2013 13:38:14 -0800
> 
> 
> The patch titled
>      Subject: mm, memcg: add memory.oom_control notification for system oom
> has been removed from the -mm tree.  Its filename was
>      mm-memcg-add-memoryoom_control-notification-for-system-oom.patch
> 
> This patch was dropped because an updated version will be merged

Why is this removed?

I've laid out my perspective for doing userspace oom handling and this is 
a vital part for system oom handling.  I know that we are currently 
discussing alternative proposals but my proposal is by far the most 
complete and allows the most powerful policies to be implemented in 
userspace.  I'd prefer if we would keep the patch unless an actual 
alternative is proposed and agreed upon, we can still discuss alternatives 
while this in -mm and this patch in no way precludes other mechanisms from 
being implemented.

So why remove this?

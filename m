Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaAVFYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 00:24:51 -0500
Received: from mail-yk0-f170.google.com ([209.85.160.170]:57039 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaAVFYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 00:24:49 -0500
Date: Tue, 21 Jan 2014 21:24:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: atomlin@redhat.com
cc: linux-kernel@vger.kernel.org, mingo@kernel.org, oleg@redhat.com,
        riel@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC PATCH v4 2/2] hung_task: Display every hung task warning
In-Reply-To: <1390239253-24030-3-git-send-email-atomlin@redhat.com>
Message-ID: <alpine.DEB.2.02.1401212124110.13234@chino.kir.corp.google.com>
References: <1390239253-24030-1-git-send-email-atomlin@redhat.com> <1390239253-24030-3-git-send-email-atomlin@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014, atomlin@redhat.com wrote:

> From: Aaron Tomlin <atomlin@redhat.com>
> 
> When khungtaskd detects hung tasks, it prints out
> backtraces from a number of those tasks.
> Limiting the number of backtraces being printed
> out can result in the user not seeing the information
> necessary to debug the issue. The hung_task_warnings
> sysctl controls this feature.
> 
> This patch makes it possible for hung_task_warnings
> to accept a special value to print an unlimited
> number of backtraces when khungtaskd detects hung
> tasks.
> 
> The special value is -1. To use this value it is
> necessary to change types from ulong to int.
> 
> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>

Nice documentation updates!

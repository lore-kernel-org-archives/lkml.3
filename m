Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3C1TXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 15:23:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab3C1TXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 15:23:38 -0400
Message-ID: <5154985D.9050001@redhat.com>
Date: Thu, 28 Mar 2013 15:22:05 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/13] rwsem: simplify rwsem_down_read_failed
References: <1363344869-15732-1-git-send-email-walken@google.com> <1363344869-15732-5-git-send-email-walken@google.com>
In-Reply-To: <1363344869-15732-5-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 06:54 AM, Michel Lespinasse wrote:
> When trying to acquire a read lock, the RWSEM_ACTIVE_READ_BIAS adjustment
> doesn't cause other readers to block, so we never have to worry about waking
> them back after canceling this adjustment in rwsem_down_read_failed().
>
> We also never want to steal the lock in rwsem_down_read_failed(), so we
> don't have to grab the wait_lock either.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Reviewed-by: Rik van Riel <riel@redhat.com>


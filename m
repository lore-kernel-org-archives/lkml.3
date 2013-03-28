Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3C1VCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 17:02:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab3C1VCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 17:02:47 -0400
Message-ID: <5154AFA2.7060005@redhat.com>
Date: Thu, 28 Mar 2013 17:01:22 -0400
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
Subject: Re: [PATCH v2 08/13] rwsem: avoid taking wait_lock in rwsem_down_write_failed
References: <1363344869-15732-1-git-send-email-walken@google.com> <1363344869-15732-9-git-send-email-walken@google.com>
In-Reply-To: <1363344869-15732-9-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 06:54 AM, Michel Lespinasse wrote:
> In rwsem_down_write_failed(), if there are active locks after we wake up
> (i.e. the lock got stolen from us), skip taking the wait_lock and go back
> to sleep immediately.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237Ab3CMVeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 17:34:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933309Ab3CMVeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 17:34:05 -0400
Message-ID: <5140F0B0.8060903@redhat.com>
Date: Wed, 13 Mar 2013 17:33:36 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] rwsem: make the waiter type an enumeration rather
 than a bitmask
References: <1362612111-28673-1-git-send-email-walken@google.com> <1362612111-28673-2-git-send-email-walken@google.com>
In-Reply-To: <1362612111-28673-2-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 06:21 PM, Michel Lespinasse wrote:
> We are not planning to add some new waiter flags, so we can convert the
> waiter type into an enumeration.
>
> Background: David Howells suggested I do this back when I tried adding
> a new waiter type for unfair readers. However, I believe the cleanup
> applies regardless of that use case.

Given the discussion on patch 10/12 and 11/12, could we benefit
from the fair vs. unfair distinction?

> Signed-off-by: Michel Lespinasse <walken@google.com>


-- 
All rights reversed

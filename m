Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaFDULn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 16:11:43 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:40528 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaFDULm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 16:11:42 -0400
Message-ID: <1401912696.13877.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC PATCH 2/3] locking/mutex: Correct documentation on mutex
 optimistic spinning
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, tim.c.chen@linux.intel.com,
        peter@hurleysoftware.com, riel@redhat.com, hpa@zytor.com,
        walken@google.com, Waiman.Long@hp.com, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Date: Wed, 04 Jun 2014 13:11:36 -0700
In-Reply-To: <1401908911-8947-3-git-send-email-jason.low2@hp.com>
References: <1401908911-8947-1-git-send-email-jason.low2@hp.com>
	 <1401908911-8947-3-git-send-email-jason.low2@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 12:08 -0700, Jason Low wrote:
> The mutex optimistic spinning documentation states that we spin for
> acquisition when we find that there are no pending waiters. However,
> in actuality, whether or not there are waiters for the mutex doesn't
> determine if we will spin for it.
> 
> This patch removes that statement and also adds a comment which
> mentions that we spin for the mutex while we don't need to reschedule.
> 
> Signed-off-by: Jason Low <jason.low2@hp.com>

Acked-by: Davidlohr Bueso <davidlohr@hp.com>

I think this could go in with v4 of the mutex doc rewrite patch...
guessing for 3.17 now.

Thanks,
Davidlohr


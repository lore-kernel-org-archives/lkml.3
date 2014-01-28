Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaA1VJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:09:29 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:20956 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705AbaA1VJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:09:28 -0500
Message-ID: <1390943366.11839.8.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 1/5] mutex: In mutex_can_spin_on_owner(), return
 false if task need_resched()
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com
Date: Tue, 28 Jan 2014 13:09:26 -0800
In-Reply-To: <1390936396-3962-2-git-send-email-jason.low2@hp.com>
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>
	 <1390936396-3962-2-git-send-email-jason.low2@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 11:13 -0800, Jason Low wrote:
> The mutex_can_spin_on_owner() function should also return false if the
> task needs to be rescheduled to avoid entering the MCS queue when it
> needs to reschedule.
> 
> Signed-off-by: Jason Low <jason.low2@hp.com>

Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>


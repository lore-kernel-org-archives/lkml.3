Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaEASjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:39:00 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:2763 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaEASi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:38:59 -0400
Message-ID: <1398969532.4884.1.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] rwsem: Comments to explain the meaning of the rwsem's
 count field
From: Davidlohr Bueso <davidlohr@hp.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Shi <alex.shi@linaro.org>, Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, linux-kernel@vger.kernel.org
Date: Thu, 01 May 2014 11:38:52 -0700
In-Reply-To: <1398966637.2970.129.camel@schen9-DESK>
References: <1398966637.2970.129.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-01 at 10:50 -0700, Tim Chen wrote:
> It takes me a while to understand how rwsem's count field mainifest
> itself in different scenarios.  I'm adding comments to provide a quick
> reference on the the rwsem's count field for each scenario where readers
> and writers are contending/holding the lock.  Hopefully it will be useful
> for future maintenance of the code and for people to get up to speed on
> how the logic in the code works.

Agreed, this is nice to have. I'm planning on sending a minor set of
patches for rwsem once the optistic spinning stuff is taken. To simplify
things, I can take this in the series and resend along with the others.

Thanks,
Davidlohr


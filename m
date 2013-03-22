Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab3CVJDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 05:03:52 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:57505 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab3CVJDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 05:03:49 -0400
Message-ID: <514C1E2A.8070308@synopsys.com>
Date: Fri, 22 Mar 2013 14:32:34 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "Peter Zijlstra" <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 06/34] arc: Use generic idle loop
References: <20130321214930.752934102@linutronix.de> <20130321215233.711253792@linutronix.de>
In-Reply-To: <20130321215233.711253792@linutronix.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.153]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> On 03/22/2013 03:23 AM, Thomas Gleixner wrote:

While the ARC specific changes look simple enough, do you have the series put up
somewhere which I can merge to give a quick build/run test.

Are you planning to add this to linux-next at some point as that will make it
really trivial to test out.

Thx,
-Vineet

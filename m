Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3KFTWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:22:39 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:53226 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab3KFTWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:22:37 -0500
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Nov 2013 14:22:37 EST
Message-ID: <527A94C8.2020907@hp.com>
Date: Wed, 06 Nov 2013 14:13:12 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v2 3/4] MCS Lock: Barrier corrections
References: <cover.1383670202.git.tim.c.chen@linux.intel.com>  <1383673356.11046.279.camel@schen9-DESK>  <20131105183744.GJ26895@mudshark.cambridge.arm.com>  <1383679317.11046.293.camel@schen9-DESK>  <20131105211803.GS28601@twins.programming.kicks-ass.net>  <20131106144520.GK18245@linux.vnet.ibm.com> <1383762133.11046.339.camel@schen9-DESK>
In-Reply-To: <1383762133.11046.339.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim,

I have just sent out a patch as an addendum to your patch series. 
Hopefully that will address the memory barrier issue.

-Longman

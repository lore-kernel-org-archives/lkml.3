Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803Ab3D3WTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 18:19:24 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:54579 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab3D3WTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 18:19:21 -0400
Date: Tue, 30 Apr 2013 15:19:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        paul.mckenney@linaro.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org
Subject: Re: rcu: Provide compile-time control for no-CBs CPUs
Message-ID: <20130430221915.GM3780@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130430214826.GK3780@linux.vnet.ibm.com>
 <20130430220647.GA16524@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430220647.GA16524@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13043022-5518-0000-0000-00000E2136B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 06:06:47PM -0400, Dave Jones wrote:
> On Tue, Apr 30, 2013 at 02:48:26PM -0700, Paul E. McKenney wrote:
> 
>  > <snip excellent explanation>
>  >
>  > Should I add this to the Kconfig help text?  My guess is "not all of it",
>  > but figured I should ask.
> 
> The commit msg would have been a great place for much of it, especially
> the part explaining your desire to have users kick the tires etc.

Good point, will keep that in mind for next time.

>  >  See below for my current best guess.
> 
> Much better. Be sure to pass on the 'terrible kconfig' award to the
> next lucky recipient when their time comes :)

Interesting.  Who passed it to you, and what was the occasion?  ;-)

							Thanx, Paul


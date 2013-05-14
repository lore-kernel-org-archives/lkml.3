Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3ENBVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:21:15 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:55247 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab3ENBVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:21:11 -0400
Date: Tue, 14 May 2013 03:21:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Dave Jones <davej@redhat.com>, paulmck@linux.vnet.ibm.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: rcu_preempt running flat out on idle desktop.
Message-ID: <20130514012105.GB12749@somewhere>
References: <20130508203042.GA18895@redhat.com>
 <CAFTL4hwB3XZG+C9pQ0JD4h=n_ObNH6mCBRfLW3JaxohwwRDWRA@mail.gmail.com>
 <20130509211026.GA22723@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509211026.GA22723@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 05:10:26PM -0400, Dave Jones wrote:
> On Thu, May 09, 2013 at 11:02:08PM +0200, Frederic Weisbecker wrote:
> 
>  > > RCU options for this build are..
>  > >
>  > I can't reproduce that issue even with the above setting. Could you
>  > please send me your whole config?
> 
> http://paste.fedoraproject.org/11363/36813375/raw/

Sorry it took me some time to get that config booting, I ran into
other unrelated crashes.

So I'm observing the exact opposite than you: the processes appear to
have no load nor to consume cputime. Even if I use some dumb user loop.
Top don't even show it.

I'm digging further and will tell you when I get more info.

Thanks.

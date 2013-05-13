Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab3EMCM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:12:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab3EMCM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:12:56 -0400
Date: Mon, 13 May 2013 10:12:36 +0800
From: Dong Zhu <bluezhudong@gmail.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Matthew Vick <matthew.vick@intel.com>,
        Jacob Keller <Jacob.e.keller@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH] igb: add a method to get the nic hw time stamping
 policy
Message-ID: <20130513021236.GJ8399@zhudong.nay.redhat.com>
References: <20130511140219.GG8399@zhudong.nay.redhat.com>
 <518E7723.5010003@cogentembedded.com>
 <20130512142555.GI8399@zhudong.nay.redhat.com>
 <20130512172446.GA2484@netboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130512172446.GA2484@netboy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 07:24:46PM +0200, Richard Cochran wrote:
> On Sun, May 12, 2013 at 10:25:55PM +0800, Dong Zhu wrote:
> > Thanks for your pointing out my mistakes of CodingStyle.
> > 
> > > > struct hwtstamp_config {
> > > >+	int rw;
> > 
> > My initial idea was that the type of rw should be enum like tx_type, but I am
> > not sure whther it is necessary to define a new enum, if this patch could
> > be accpeted I will ask someone about the rw. At that time I will change
> > the type of rw to bool or define a new enum, then convert the if to
> > switch if necessary.
> 
> You cannot add any new field at all. That would break a userland ABI.
> 

Thanks for your info Richard.

Can I use the 'flags' which members of hwtstamp_config to judge the
ioctl request instead ? If not could you plz give me a new way to
resolve this issue ?

Thanks a lot !

-- 
Best Regards,
Dong Zhu

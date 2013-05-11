Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3EKPcB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 11:32:01 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:63601 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab3EKPb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 11:31:59 -0400
Date: Sat, 11 May 2013 17:31:43 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Dong Zhu <bluezhudong@gmail.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
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
Message-ID: <20130511153143.GA25180@netboy>
References: <20130511140219.GG8399@zhudong.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130511140219.GG8399@zhudong.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 10:02:19PM +0800, Dong Zhu wrote:
> 
> Currently kernel only support setting the hw time stamping policy
> through ioctl,now add a method to check which packets(Outgoing and
> Incoming) are time stamped by nic.

I don't really see a use case here. Applications needing time stamping
should just set the policy that they need.

>  struct hwtstamp_config {
> +	int rw;

Also, you can't just go adding fields to an ioctl.

>  	int flags;
>  	int tx_type;
>  	int rx_filter;
> -- 

Thanks,
Richard

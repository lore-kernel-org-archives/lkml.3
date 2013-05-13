Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3EMEb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 00:31:58 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:34759 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3EMEb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 00:31:57 -0400
Date: Mon, 13 May 2013 06:31:40 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Dong Zhu <bluezhudong@gmail.com>
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
Message-ID: <20130513043140.GA2567@netboy>
References: <20130511140219.GG8399@zhudong.nay.redhat.com>
 <518E7723.5010003@cogentembedded.com>
 <20130512142555.GI8399@zhudong.nay.redhat.com>
 <20130512172446.GA2484@netboy>
 <20130513021236.GJ8399@zhudong.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513021236.GJ8399@zhudong.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 10:12:36AM +0800, Dong Zhu wrote:
> 
> Can I use the 'flags' which members of hwtstamp_config to judge the
> ioctl request instead ? If not could you plz give me a new way to
> resolve this issue ?

You could use the flags field, as it has no definition yet.

But you still need to explain why this new functionality is needed in
the first place:

- You can query an interface's time stamping capabilities with the
  GET_TS_INFO ethtool command.

- You can choose a setting with SIOCSHWTSTAMP.

What more do you need?

Thanks,
Richard

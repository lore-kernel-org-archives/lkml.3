Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbaEFVIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:08:21 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46727 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbaEFVIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:08:19 -0400
Date: Tue, 6 May 2014 14:08:15 -0700
From: josh@joshtriplett.org
To: David Miller <davem@davemloft.net>
Cc: xiyou.wangcong@gmail.com, andi@firstfloor.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com,
        ak@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140506210815.GB21791@cloud>
References: <20140506.131643.994244006906866938.davem@davemloft.net>
 <20140506175547.GE20776@cloud>
 <CAM_iQpUgj7BqpzRL070DEGQ32SWwN68BRgM5DtFqvBLjGGOLQA@mail.gmail.com>
 <20140506.164410.15377655213427639.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506.164410.15377655213427639.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 04:44:10PM -0400, David Miller wrote:
> From: Cong Wang <xiyou.wangcong@gmail.com>
> Date: Tue, 6 May 2014 11:33:11 -0700
> 
> > So why bothers 3.15+ Linux kernel? Why not use an old kernel e.g. 2.4.x?
> > 2.4.x kernel doesn't have so many new features you want to get rid of here.
> 
> +1

You've got to be kidding.  Using 2.4 for a new network-connected device,
today?  With all of its potential security holes that nobody is paying
attention to?  Easier to fork 3.15 and trim it down than to do *that*.
And there *are* a huge number of useful features in 3.15+, not least of
which drivers for current hardware.

- Josh Triplett

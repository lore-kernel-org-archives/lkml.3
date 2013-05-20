Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3ETI3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 04:29:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42500 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752110Ab3ETI3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 04:29:49 -0400
Message-ID: <1369038587.2143.12.camel@joe-AO722>
Subject: Re: [PATCH v2 net-next 1/4] net: implement support for low latency
 socket polling
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: eliezer.tamir@linux.intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        donanld.c.skidmore@intel.com, e1000-devel@lists.sourceforge.net,
        willemb@google.com, andi@firstfloor.org, hpa@zytor.com,
        eliezer@tamir.org.il
Date: Mon, 20 May 2013 01:29:47 -0700
In-Reply-To: <20130520.005447.972811583292360876.davem@davemloft.net>
References: <20130519102525.12527.83301.stgit@ladj378.jer.intel.com>
	 <20130519102533.12527.12991.stgit@ladj378.jer.intel.com>
	 <20130520.005447.972811583292360876.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-20 at 00:54 -0700, David Miller wrote:
> From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
[]
> >  {
> >       struct socket *sock;
> > +     unsigned int poll_result;
> 
> Please order local variable declarations from longest line to
> shortest line.

reverse christmas tree doesn't seem especially valuable or
sensible for automatics.

I'd rather order by first use or even alphabetical, especially
with long lists of automatics.




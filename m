Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263Ab3E1NoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:44:14 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:57461 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759083Ab3E1NoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:44:12 -0400
Message-ID: <1369748650.3301.535.camel@edumazet-glaptop>
Subject: Re: [PATCH v5 net-next 3/5] tcp: add TCP support for low latency
 receive poll.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 28 May 2013 06:44:10 -0700
In-Reply-To: <51A49FDC.2020608@linux.intel.com>
References: <20130527074351.29882.51106.stgit@ladj378.jer.intel.com>
	  <20130527074421.29882.73968.stgit@ladj378.jer.intel.com>
	 <1369701413.3301.506.camel@edumazet-glaptop>
	 <51A46A21.9060305@linux.intel.com> <51A49FDC.2020608@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 15:15 +0300, Eliezer Tamir wrote:

> >> How IPv6 is handled ?
> 
> It turns out that adding TCPv6/UDPv6 is very simple.

Yep, I was about to send you the needed lines after my breakfast ;)




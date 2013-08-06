Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3HFKOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:14:52 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:48126 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab3HFKOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:14:50 -0400
Message-ID: <1375784088.4457.74.camel@edumazet-glaptop>
Subject: Re: [PATCH net] net: rename and move busy poll mib counter
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, Shawn Bohrer <sbohrer@rgmadvisors.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 06 Aug 2013 03:14:48 -0700
In-Reply-To: <20130806095207.5887.2196.stgit@ladj378.jer.intel.com>
References: <20130806095207.5887.2196.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 12:52 +0300, Eliezer Tamir wrote:
> Move the low latency mib counter to the ip section.
> Rename it from low latency to busy poll.
> 
> Reported-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---

Well, it should not be part of IP mib, but a socket one (not existing so
far)

Linux MIB already contains few non TCP counters :

LINUX_MIB_ARPFILTER
LINUX_MIB_IPRPFILTER

Its mostly populated by TCP counters, sure.



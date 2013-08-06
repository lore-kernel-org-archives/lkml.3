Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab3HFKdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:33:54 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57290 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab3HFKdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:33:52 -0400
Message-ID: <1375785230.4457.77.camel@edumazet-glaptop>
Subject: Re: [PATCH net] net: rename and move busy poll mib counter
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, Shawn Bohrer <sbohrer@rgmadvisors.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 06 Aug 2013 03:33:50 -0700
In-Reply-To: <5200CE8A.1090707@linux.intel.com>
References: <20130806095207.5887.2196.stgit@ladj378.jer.intel.com>
	 <1375784088.4457.74.camel@edumazet-glaptop>
	 <5200CE8A.1090707@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 13:23 +0300, Eliezer Tamir wrote:

> So, just rename it to busy poll?
> Or maybe just drop the whole patch?

I guess a rename would be fine.



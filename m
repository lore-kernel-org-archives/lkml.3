Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab3CDOwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:52:53 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:63225 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325Ab3CDOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:52:51 -0500
Message-ID: <1362408768.15793.89.camel@edumazet-glaptop>
Subject: Re: [RFC PATCH 1/5] net: implement support for low latency socket
 polling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Mon, 04 Mar 2013 06:52:48 -0800
In-Reply-To: <51345EB8.9050309@linux.intel.com>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
	  <20130227175555.10611.42794.stgit@gitlad.jf.intel.com>
	 <1362335704.15793.81.camel@edumazet-glaptop>
	 <51345EB8.9050309@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-04 at 10:43 +0200, Eliezer Tamir wrote:

> One could for example increment the generation id every time the RTNL is 
> taken. or is this too much?

RTNL is taken for a lot of operations, it would be better to have a
finer grained increment.



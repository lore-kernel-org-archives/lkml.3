Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3C2T01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:26:27 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:42773 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab3C2T0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:26:25 -0400
Message-ID: <1364585182.5113.58.camel@edumazet-glaptop>
Subject: Re: [PATCH] net: add a synchronize_net() in
 netdev_rx_handler_unregister()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Jiri Pirko <jpirko@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Nicolas de =?ISO-8859-1?Q?Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guy Streeter <streeter@redhat.com>, stephen@networkplumber.org
Date: Fri, 29 Mar 2013 12:26:22 -0700
In-Reply-To: <20130329192011.GO3320@linux.vnet.ibm.com>
References: <1364490997.6345.237.camel@gandalf.local.home>
	 <1364491792.15753.47.camel@edumazet-glaptop>
	 <20130329094856.GB1677@minipsycho.orion>
	 <1364562082.5113.16.camel@edumazet-glaptop>
	 <20130329192011.GO3320@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-29 at 12:20 -0700, Paul E. McKenney wrote:

> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> With kudos to Steven Rostedt for his analogy between RCU and
> Schrödinger's cat.  ;-)

Thanks Paul !



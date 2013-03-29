Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab3C2QM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:12:26 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:37730 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab3C2QMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:12:24 -0400
Date: Fri, 29 Mar 2013 17:12:19 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ivan Vecera <ivecera@redhat.com>, Jiri Pirko <jpirko@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Nicolas de =?iso-8859-1?Q?Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guy Streeter <streeter@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, stephen@networkplumber.org
Subject: Re: [PATCH] net: add a synchronize_net() in
 netdev_rx_handler_unregister()
Message-ID: <20130329161219.GA1668@minipsycho.orion>
References: <1364490997.6345.237.camel@gandalf.local.home>
 <1364491792.15753.47.camel@edumazet-glaptop>
 <20130329094856.GB1677@minipsycho.orion>
 <1364562082.5113.16.camel@edumazet-glaptop>
 <5155AF24.3090305@redhat.com>
 <1364571495.5113.23.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364571495.5113.23.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fri, Mar 29, 2013 at 04:38:15PM CET, eric.dumazet@gmail.com wrote:
>On Fri, 2013-03-29 at 16:11 +0100, Ivan Vecera wrote:
>
>> Erik, why doesn't help the write barrier between the assignments. It 
>> should guarantee their orders... or not?
>> 
>
>Its not enough, I wont explain here why as RCU is quite well documented
>in Documentation/RCU

Can you point me exact paragraph? I'm unable to find that :(

>
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe netdev" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

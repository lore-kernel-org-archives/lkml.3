Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab3A1F0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 00:26:53 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:61950 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3A1F0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 00:26:51 -0500
MIME-Version: 1.0
In-Reply-To: <5105E6F2.2010805@gmail.com>
References: <1358874800.3464.4002.camel@edumazet-glaptop>
	<50FED7CE.1030008@hp.com>
	<20130122184245.GJ4608@sociomantic.com>
	<50FF0C25.9000300@hp.com>
	<20130123104736.GK4608@sociomantic.com>
	<510039C8.7040401@hp.com>
	<20130124122223.GQ4608@sociomantic.com>
	<51018110.1070403@hp.com>
	<20130124192125.GD4608@sociomantic.com>
	<5102225E.2040506@gmail.com>
	<20130125100525.GE4608@sociomantic.com>
	<5105E6F2.2010805@gmail.com>
Date: Sun, 27 Jan 2013 21:21:32 -0800
Message-ID: <CAGK4HS_2=b3gJmDeBTbSmFYk4PB2epMUQE6nkr1XMGfFgmfHvw@mail.gmail.com>
Subject: Re: Doubts about listen backlog and tcp_max_syn_backlog
From: Vijay Subramanian <subramanian.vijay@gmail.com>
To: Nivedita Singhvi <niveditasinghvi@gmail.com>
Cc: Leandro Lucarella <leandro.lucarella@sociomantic.com>,
        Rick Jones <rick.jones2@hp.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +    { "ListenDrops", N_("%u SYNs to LISTEN sockets dropped"), opt_number },
>
> (see the file debian/patches/CVS-20081003-statistics.c_sync.patch
>  in the net-tools src)
>
> i.e., the netstat pkg is printing the value of the TCPEXT MIB counter
> that's counting TCPExtListenDrops.
>
> Theoretically, that number should be the same as that printed by nstat,
> as they are getting it from the same kernel stats counter. I have not
> looked at nstat code (I actually almost always dump the counters from
> /proc/net/{netstat + snmp} via a simple prettyprint script (will send
> you that offline).
>

nstat pretty much does what you describe which is to parse the
/proc/net files(s) and
print the contents. This is one advantage of nstat over netstat. When
you add a new MIB, you
do not need to update nstat.

> If the nstat and netstat counters don't match, something is fishy.
> That nstat output is broken.
>
